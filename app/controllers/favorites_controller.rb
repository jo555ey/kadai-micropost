class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    user = User.find(params[:micropost_id])
    current_user.micropost(user)
    flash[:success] = 'お気に入りに登録しました。'
    redirect_to user
  end

  def destroy
    user = User.find(params[:micropost_id])
    current_user.unmicropost(user)
    flash[:success] = 'お気に入り登録を解除しました。'
    redirect_to user
  end
end
