class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.order(:name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "Account for #{@user.name} created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    params_to_update = user_params
    # Only update password fields if the admin actually typed a new one.
    params_to_update = params_to_update.except(:password, :password_confirmation) if params_to_update[:password].blank?

    if @user.update(params_to_update)
      redirect_to users_path, notice: "User updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User removed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
