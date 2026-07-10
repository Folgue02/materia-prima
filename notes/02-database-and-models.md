# 02 — Database & Models

## The data model

```
users
  id, name, email, password_digest, admin, created_at, updated_at

food_funds
  id, name, description, created_at, updated_at

subscriptions          ← join table: "user belongs to food fund"
  id, user_id, food_fund_id, created_at, updated_at

spendings
  id, user_id, food_fund_id, amount, description, created_at, updated_at
```

---

## Migrations — Rails' way of changing the DB schema

In PHP/Laravel you might write:
```php
Schema::create('food_funds', function (Blueprint $table) {
    $table->id();
    $table->string('name');
    $table->timestamps();
});
```

In Rails it looks like:
```ruby
class CreateFoodFunds < ActiveRecord::Migration[8.1]
  def change
    create_table :food_funds do |t|
      t.string :name, null: false

      t.timestamps  # adds created_at and updated_at automatically
    end
  end
end
```

Rails generates the migration file for you:
```bash
bin/rails generate migration CreateFoodFunds name:string description:text
```

Then you run it:
```bash
bin/rails db:migrate
```

**Key difference from PHP:** Rails tracks which migrations have run in a `schema_migrations` table, exactly like Laravel does.

---

## Models — ActiveRecord

Each model maps to a table. Rails auto-discovers columns from the DB, so you don't declare them like in Eloquent with `$fillable`. The model is for **behaviour**, not just column listing.

### User model (`app/models/user.rb`)

```ruby
class User < ApplicationRecord
  has_secure_password          # magic from bcrypt gem — adds authenticate() method

  has_many :subscriptions, dependent: :destroy   # like $this->hasMany(Subscription::class)
  has_many :food_funds, through: :subscriptions  # many-to-many via the join table
  has_many :spendings, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
```

**`has_secure_password`** is a Rails built-in that:
1. Requires `password_digest` column in the DB
2. Adds `authenticate("plain_text")` method that bcrypt-compares the hash
3. Adds `password` and `password_confirmation` virtual attributes

The PHP equivalent would be manually doing `password_verify($input, $hash)`.

### FoodFund model — the roulette logic

```ruby
def next_payer
  return nil if users.empty?

  subscribers = users.order("subscriptions.created_at ASC")
  last_spending = spendings.order(created_at: :desc).first

  return subscribers.first unless last_spending

  last_payer_index = subscribers.index(last_spending.user)
  subscribers[(last_payer_index + 1) % subscribers.size]
end
```

The `%` is modulo. If there are 3 subscribers (indices 0,1,2) and the last payer was index 2, then `(2 + 1) % 3 = 0`, wrapping back to the first subscriber. Clean round-robin.

### Associations — the Rails "magic"

```ruby
# In Food Fund model:
has_many :users, through: :subscriptions

# This gives you methods like:
fund.users           # all subscribed users
fund.users.count     # count
fund.users << alice  # subscribe alice (inserts into subscriptions table)
```

Equivalent in Eloquent:
```php
// In FoodFund model:
public function users(): BelongsToMany
{
    return $this->belongsToMany(User::class, 'subscriptions');
}
```
