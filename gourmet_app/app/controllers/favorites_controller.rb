class FavoritesController < ApplicationController

  def create
    shop_id = params[:shop_id]
    favorite = current_user.favorites.new(shop_id: shop_id)
    favorite.save
    redirect_to request.referer
  end

  def destroy
    shop_id = params[:shop_id]
    favorite = current_user.favorites.find_by(shop_id: shop_id)
    favorite.destroy
    redirect_to request.referer
  end
end
