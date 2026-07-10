# 03 — Routing & Controllers

## Routes (`config/routes.rb`)

```ruby
Rails.application.routes.draw do
  root "dashboard#index"   # GET / → DashboardController#index

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :users

  resources :food_funds do
    resource  :subscription, only: %i[create destroy]  # singular: one per user+fund
    resources :spendings,    only: %i[new create]
  end
end
```

`resources :food_funds` generates:

| Verb | URL | Controller action | Named route |
|------|-----|-------------------|-------------|
| GET | /food_funds | food_funds#index | `food_funds_path` |
| GET | /food_funds/new | food_funds#new | `new_food_fund_path` |
| POST | /food_funds | food_funds#create | `food_funds_path` |
| GET | /food_funds/:id | food_funds#show | `food_fund_path(fund)` |
| GET | /food_funds/:id/edit | food_funds#edit | `edit_food_fund_path(fund)` |
| PATCH | /food_funds/:id | food_funds#update | `food_fund_path(fund)` |
| DELETE | /food_funds/:id | food_funds#destroy | `food_fund_path(fund)` |

Nested resources produce URLs like `/food_funds/3/spendings/new`.

---

## ApplicationController — shared behaviour for all controllers

```ruby
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :admin?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
```

`helper_method` makes `current_user`, `logged_in?`, and `admin?` available inside **views** too (not just controllers). In Laravel you'd use `Auth::user()` in Blade templates; here you get the same via helper methods.

`@current_user ||= ...` is memoisation — if `@current_user` is already set, skip the DB query. Very common Ruby pattern.

---

## before_action — like middleware, but per-controller

```ruby
class FoodFundsController < ApplicationController
  before_action :require_login                         # all actions
  before_action :require_admin, only: %i[new create]  # only these two
  before_action :set_food_fund, only: %i[show edit]   # DRY: load the record once
```

`before_action` runs a method before specified actions. If the method calls `redirect_to`, Rails skips the action entirely. This is how we guard admin-only pages.

In Laravel you'd use middleware. Rails' `before_action` is closer but lives inside the controller class.

---

## Sessions — authentication without Devise

We're doing auth manually so you learn how it works.

```ruby
# sessions_controller.rb
def create
  user = User.find_by(email: params[:email].to_s.downcase)

  if user&.authenticate(params[:password])
    session[:user_id] = user.id      # store user id in server-side session
    redirect_to root_path
  else
    flash.now[:alert] = "Invalid email or password."
    render :new, status: :unprocessable_entity
  end
end
```

`user&.authenticate(...)` — the `&.` is Ruby's "safe navigation operator". If `user` is `nil` (no user found), it returns `nil` instead of raising a NoMethodError. Equivalent to `user && user.authenticate(...)`.

`session[:user_id]` stores data in an encrypted cookie (Rails does this automatically). On the next request, Rails decrypts it and `session[:user_id]` is available again.

`flash.now[:alert]` shows an alert on the **current** render. Regular `flash[:alert]` would persist to the **next** request (after a redirect).

---

## Flash messages

`flash` is a temporary message store that survives exactly one redirect:

```ruby
# In controller
redirect_to root_path, notice: "Welcome back!"

# In layout (application.html.erb)
<% if flash[:notice] %>
  <div class="alert alert-success"><%= flash[:notice] %></div>
<% end %>
```

`notice:` is a shorthand for `flash[:notice] =`. Both `:notice` (green) and `:alert` (red) are conventional names.
