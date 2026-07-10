class SpendingsController < ApplicationController
  before_action :require_login
  before_action :set_food_fund
  before_action :require_subscription

  def new
    @spending = Spending.new
  end

  def create
    @spending = current_user.spendings.build(spending_params.merge(food_fund: @food_fund))

    if @spending.save
      redirect_to @food_fund, notice: "Spending of €#{@spending.amount} logged!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_food_fund
    @food_fund = FoodFund.find(params[:food_fund_id])
  end

  def require_subscription
    unless current_user.subscribed_to?(@food_fund)
      flash[:alert] = "You must be subscribed to log a spending."
      redirect_to @food_fund
    end
  end

  def spending_params
    params.require(:spending).permit(:amount, :description)
  end
end
