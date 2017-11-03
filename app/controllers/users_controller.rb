class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :micropostings, :microposters]
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def micropostings
    @user = User.find(params[:id])
    @micropostings = @user.micropostings.page(params[:page])
    counts(@user)
  end
  
  def microposts
    @user = User.find(params[:id])
    @microposters = @user.microposters.page(params[:page])
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
