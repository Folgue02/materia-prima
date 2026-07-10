class FoodFund < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions
  has_many :spendings, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def total_spent
    spendings.sum(:amount)
  end

  # Returns the user who should pay next, based on round-robin rotation.
  # Cycles through subscribers in subscription order; the subscriber after
  # whoever paid last goes next.
  def next_payer
    return nil if users.empty?

    subscribers = users.order("subscriptions.created_at ASC")
    last_spending = spendings.order(created_at: :desc).first

    return subscribers.first unless last_spending

    last_payer_index = subscribers.index(last_spending.user)

    # If the last payer was removed from subscriptions, start from the beginning.
    return subscribers.first if last_payer_index.nil?

    subscribers[(last_payer_index + 1) % subscribers.size]
  end
end
