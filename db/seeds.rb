# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#price unit is cents, 1$ = 100 cents
SubscriptionPlan.create(name: 'Free', price: 0, daily_article_limit: 1)
SubscriptionPlan.create(name: 'Basic', price: 300, daily_article_limit: 3)
SubscriptionPlan.create(name: 'Standard', price: 500, daily_article_limit: 5)
SubscriptionPlan.create(name: 'Premium', price: 1000, daily_article_limit: 10)