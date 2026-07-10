class DashboardController < ApplicationController
  before_action :require_login

  def index
    @subscribed_funds = current_user.food_funds.includes(:spendings)
    @available_funds = FoodFund.where.not(id: @subscribed_funds).order(:name)
    @total_spent = current_user.total_spent
  end
end
