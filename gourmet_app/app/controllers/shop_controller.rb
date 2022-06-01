class ShopController < ApplicationController
  require 'net/http'
  require 'rexml/document'
  require "open-uri"
  require 'nokogiri'
  require 'uri'

  def index
    lat = params[:lat]
    lng = params[:lng]
    # lat, lngに位置情報が取得できるとき
    if (lat != "lat") || (lng != "lng")
      if range = params[:range]
        data = URI.encode_www_form({lat: lat, lng: lng, range: range})
        uri = URI.parse("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{ ENV['GOURMET_SEARCH_API'] }&#{data}")
        puts uri
        # index_shopメソッドから配列データの取得
        array = index_shop(uri)
        @contents = Kaminari.paginate_array(array).page(params[:page]).per(5)
      end
    end
    @info = "取得できるデータがありません。"
  end

  def show
    id = params[:id]
    data = URI.encode_www_form({id: id})
    uri = URI.parse("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{ ENV['GOURMET_SEARCH_API'] }&#{data}")
    puts uri
    doc = Nokogiri::HTML(open(uri),nil,"utf-8")
    @shop = doc.xpath('//results//shop')
  end

  private

  # 配列の作成
  def index_shop(uri)
    doc = Nokogiri::HTML(open(uri),nil,"utf-8")
    contents = doc.xpath('//results//shop')
    array = []
    contents.each do |shop|
      array.push({
        id: shop.xpath('id').text,
        name: shop.xpath('name').text,
        address: shop.xpath('address').text,
        logo_image: shop.xpath('logo_image').text
      })
    end
    return array
  end

end
