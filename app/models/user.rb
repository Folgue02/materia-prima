class User < ApplicationRecord
  has_secure_password

  has_many :subscriptions, dependent: :destroy
  has_many :food_funds, through: :subscriptions
  has_many :spendings, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true

  before_save { self.email = email.downcase }

  def subscribed_to?(food_fund)
    food_funds.include?(food_fund)
  end

  def total_spent
    spendings.sum(:amount)
  end

  def total_spent_on(food_fund)
    spendings.where(food_fund: food_fund).sum(:amount)
  end
end
