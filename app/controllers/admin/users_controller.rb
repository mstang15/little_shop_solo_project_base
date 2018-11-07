class Admin::UsersController < ApplicationController

  before_action :require_admin

  def edit
    @user = User.find_by(slug: params[:slug])
  end

  def update
    @user = User.find_by(slug: params[:slug])
    if @user.update(user_params)
      flash[:success] = "Item updated"
      redirect_to user_path(@user)
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :city, :state, :zip, :slug)
  end

  def require_admin
    if !current_admin?
      render file: "/app/views/errors/not_found"
    end
  end

end
