class UsersController < ApplicationController
  require 'net/http'
  require 'rexml/document'
  require "open-uri"
  require 'nokogiri'
  require 'uri'

  before_action :authenticate_user!, except: [:public_action]

  def show
    @info = "お気に入り店舗が登録されていません"
    user_id = params[:id]
    # 文字列型から数値型に変換してログインしているユーザーかどうかの判定
    if current_user.id == user_id.to_i
      @user = User.find(params[:id])
      shop_id = @user.favorites
      # 配列に目的のapi_urlを保存
      array_uri = shop_uri(shop_id)
      # 配列に目的のデータを保存
      array = show_shop(array_uri)
      puts array
      unless array.empty?
        @contents = Kaminari.paginate_array(array).page(params[:page]).per(5)
      end
    else
      redirect_to user_path(current_user)
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: 'You have updated user successfully.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def shop_uri(shop_id)
    array_uri = []
    shop_id.each do |shop|
      id = shop.shop_id
      data = URI.encode_www_form({id: id})
      uri = URI.parse("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{ ENV['GOURMET_SEARCH_API'] }&#{data}")
      # urlデータの配列保存
      array_uri.push(uri)
    end
    return array_uri
  end

  def show_shop(uri_data)
    array = []
    uri_data.each do |uri|
      doc = Nokogiri::HTML(open(uri),nil,"utf-8")
      shop_data = doc.xpath('//results//shop')
      array.push({
        id: shop_data.xpath('id').text,
        name: shop_data.xpath('name').text,
        address: shop_data.xpath('address').text,
        logo_image: shop_data.xpath('logo_image').text
      })
    end
    # 取得したデータを返す
    return array
  end
end
