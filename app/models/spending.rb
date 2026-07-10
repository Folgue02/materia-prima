class Spending < ApplicationRecord
  belongs_to :user
  belongs_to :food_fund

  validates :amount, presence: true, numericality: { greater_than: 0 }
end
