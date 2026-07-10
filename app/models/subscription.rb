class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :food_fund

  validates :user_id, uniqueness: { scope: :food_fund_id, message: "is already subscribed to this food fund" }
end
