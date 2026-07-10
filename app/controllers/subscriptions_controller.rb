class SubscriptionsController < ApplicationController
  before_action :require_login
  before_action :set_food_fund

  def create
    unless current_user.subscribed_to?(@food_fund)
      current_user.subscriptions.create!(food_fund: @food_fund)
      flash[:notice] = "You joined '#{@food_fund.name}'."
    end
    redirect_to @food_fund
  end

  def destroy
    subscription = current_user.subscriptions.find_by(food_fund: @food_fund)
    subscription&.destroy
    flash[:notice] = "You left '#{@food_fund.name}'."
    redirect_to @food_fund
  end

  private

  def set_food_fund
    @food_fund = FoodFund.find(params[:food_fund_id])
  end
end
