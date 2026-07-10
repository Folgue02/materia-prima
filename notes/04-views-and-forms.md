# 04 — Views & Forms

## ERB templates — like Blade but simpler

ERB (Embedded Ruby) has only two tags:

```erb
<%= expression %>   ← outputs the result (like {{ $var }} in Blade)
<% code %>          ← executes code but outputs nothing (like @if, @foreach)
```

There's no `@endif` or `@endforeach` — you close blocks with `end`:

```erb
<% @food_funds.each do |fund| %>
  <p><%= fund.name %></p>
<% end %>

<% if admin? %>
  <a href="...">Admin panel</a>
<% end %>
```

---

## Layouts

`app/views/layouts/application.html.erb` is the master layout (like a Blade layout file).
The `<%= yield %>` call is where each view's content is inserted — equivalent to `@yield('content')` in Blade.

We also use `content_for` to pass data from views to the layout:

```erb
<%# In a view: %>
<% content_for(:title) { "Food Funds — Materia Prima" } %>

<%# In the layout: %>
<title><%= content_for(:title) || "Materia Prima" %></title>
```

---

## Forms with `form_with`

Rails has a form builder that generates correct HTML, including CSRF tokens automatically.

### Binding a form to a model

```erb
<%= form_with model: @food_fund do |f| %>
  <%= f.label :name, class: "form-label" %>
  <%= f.text_field :name, class: "form-control" %>
  <%= f.submit "Save" %>
<% end %>
```

Rails is smart about `model: @food_fund`:
- If `@food_fund` is **new** → `method="post"` → POST /food_funds
- If `@food_fund` **exists** → `method="patch"` → PATCH /food_funds/3

This is the same "new vs edit" dual-purpose form pattern you'd build in Laravel.

### Binding a form to a URL (no model)

```erb
<%= form_with url: login_path do |f| %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.submit "Log in" %>
<% end %>
```

---

## Partials — reusable view snippets

Files starting with `_` are partials. You render them with:

```erb
<%= render "form", food_fund: @food_fund %>
```

This renders `_form.html.erb` in the same directory, passing `food_fund` as a local variable. Like Blade's `@include('form', ['food_fund' => $fund])`.

---

## Nested resource forms

When posting to a nested route (e.g., POST /food_funds/3/spendings), pass an array to `form_with`:

```erb
<%= form_with model: [@food_fund, @spending] do |f| %>
```

Rails builds the URL automatically from the objects in the array.

---

## Links and buttons

```erb
<%# Simple link %>
<%= link_to "View", food_fund_path(fund) %>

<%# Button that sends a non-GET request (uses a form under the hood) %>
<%= button_to "Delete", food_fund_path(fund), method: :delete,
              data: { turbo_confirm: "Are you sure?" } %>
```

`button_to` renders a mini `<form>` with the correct method. This is how Rails handles DELETE/PATCH links (HTML only supports GET and POST natively). Turbolinks intercepts the click and shows a confirm dialog if `data: { turbo_confirm: "..." }` is set.
