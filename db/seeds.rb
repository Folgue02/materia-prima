admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name     = "Admin"
  u.password = "password"
  u.admin    = true
end

alice = User.find_or_create_by!(email: "alice@example.com") do |u|
  u.name     = "Alice"
  u.password = "password"
end

bob = User.find_or_create_by!(email: "bob@example.com") do |u|
  u.name     = "Bob"
  u.password = "password"
end

mercadona = FoodFund.find_or_create_by!(name: "Mercadona Run") do |f|
  f.description = "Weekly trip to Mercadona for the office"
end

lidl = FoodFund.find_or_create_by!(name: "Lidl Snacks") do |f|
  f.description = "Snacks and drinks from Lidl"
end

[alice, bob].each { |u| mercadona.users << u unless mercadona.users.include?(u) }
[alice].each { |u| lidl.users << u unless lidl.users.include?(u) }

Spending.find_or_create_by!(user: alice, food_fund: mercadona, amount: 18.50, description: "Fruits and veggies")
Spending.find_or_create_by!(user: bob,   food_fund: mercadona, amount: 22.00, description: "Snacks and juice")

puts "Seeded! Login with admin@example.com / password (or alice@, bob@)"
