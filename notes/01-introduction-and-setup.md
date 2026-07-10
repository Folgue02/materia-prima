# 01 — Introduction & Setup

## What we're building

**Materia Prima** is a small app for your team to track food spendings: who bought lunch, how much it cost, and — using a round-robin roulette — whose turn it is to pay next.

This is your first Rails app, and you already know PHP. Great news: you'll recognise a lot of concepts. Rails is opinionated (it makes decisions for you so you can move fast), whereas PHP gives you total freedom but asks you to make every decision yourself.

---

## The stack

| Layer | Technology | PHP equivalent |
|---|---|---|
| Language | Ruby 3.x | PHP 8.x |
| Framework | Rails 8.1 | Laravel 11 |
| Database | SQLite (dev) | MySQL/SQLite |
| Templates | ERB | Blade / plain PHP |
| CSS | Bootstrap 5 (CDN) | Bootstrap |
| Auth | has_secure_password | bcrypt + sessions |

---

## Project structure (the important parts)

```
app/
  models/           ← ActiveRecord models (your entities, like PHP classes)
  controllers/      ← Handle HTTP requests, like PHP controllers
  views/            ← HTML templates (.html.erb files)
config/
  routes.rb         ← All URL definitions in one place (like Laravel's web.php)
db/
  migrate/          ← Database migrations (same concept as in Laravel)
  seeds.rb          ← Seed data for dev/test
Gemfile             ← Like composer.json — lists your dependencies
```

In Laravel you might do:
```php
// routes/web.php
Route::get('/food-funds', [FoodFundController::class, 'index']);
```

In Rails you write:
```ruby
# config/routes.rb
resources :food_funds
```

That one `resources` line creates all 7 RESTful routes (index, show, new, create, edit, update, destroy) automatically.

---

## How we ran the app for the first time

```bash
# Install dependencies (like `composer install`)
bundle install

# Create the database and run migrations
bin/rails db:create db:migrate

# Load seed data
bin/rails db:seed

# Start the server (default port 3000)
bin/rails server
```

Then open http://localhost:3000. You'll be redirected to /login.

**Seed accounts (all password: `password`):**
- `admin@example.com` — admin, can manage users and food funds
- `alice@example.com` — regular user
- `bob@example.com` — regular user
