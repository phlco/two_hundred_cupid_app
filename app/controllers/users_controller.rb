class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
  end

  def index
    if params[:query]
      @users = User.where("email like ?", "%#{params[:query]}%")
    else
      @users = User.all
    end
  end

  def show
    redirect_to('/') unless session[:user_id]
  end

  # POST '/users'
  def create
    user = User.create(user_params)
    redirect_to profile_path
  end

  def update
    user = User.find_by(id: params[:id])
    user.update(user_params)
    redirect_to profile_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
