class FoodFundsController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: %i[new create edit update destroy]
  before_action :set_food_fund, only: %i[show edit update destroy]

  def index
    @food_funds = FoodFund.order(:name)
  end

  def show
    @spendings = @food_fund.spendings.includes(:user).order(created_at: :desc)
    @next_payer = @food_fund.next_payer
    @my_total = current_user.total_spent_on(@food_fund)
    @subscribed = current_user.subscribed_to?(@food_fund)
  end

  def new
    @food_fund = FoodFund.new
  end

  def create
    @food_fund = FoodFund.new(food_fund_params)

    if @food_fund.save
      redirect_to @food_fund, notice: "Food fund '#{@food_fund.name}' created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @food_fund.update(food_fund_params)
      redirect_to @food_fund, notice: "Food fund updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @food_fund.destroy
    redirect_to food_funds_path, notice: "Food fund deleted."
  end

  private

  def set_food_fund
    @food_fund = FoodFund.find(params[:id])
  end

  def food_fund_params
    params.require(:food_fund).permit(:name, :description)
  end
end
