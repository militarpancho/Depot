class StoreController < ApplicationController
  skip_before_action :authorize
  include CurrentCart
  before_action :set_cart
  def index
      if params[:set_locale]
        redirect_to store_url(locale: params[:set_locale])
      else
        @products = Product.order(:title)
      end
     
      @time = Time.now
  	  if session[:counter].nil?
  	  	session[:counter] = 0
  	  end
  	  session[:counter] += 1	
  	  @count = session[:counter]
	end


end
