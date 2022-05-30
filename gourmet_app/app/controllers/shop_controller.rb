class ShopController < ApplicationController
  require 'net/http'
  require 'rexml/document'
  require "open-uri"
  require 'json'
  require 'nokogiri'
  require 'uri'

  def index
    lat = params[:lat]
    lng = params[:lng]
    if range = params[:range]
      data = URI.encode_www_form({lat: lat, lng: lng, range: range})
      uri = URI.parse("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{ ENV['GOURMET_SEARCH_API'] }&#{data}")
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
      puts array
      @contents = Kaminari.paginate_array(array).page(params[:page]).per(5)
    end
  end

  def show
    id = params[:id]
    data = URI.encode_www_form({id: id})
    uri = URI.parse("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{ ENV['GOURMET_SEARCH_API'] }&#{data}")
    puts "test"
    puts uri
    doc = Nokogiri::HTML(open(uri),nil,"utf-8")
    @shop = doc.xpath('//results//shop')
    puts @contents
  end

end
