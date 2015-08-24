require 'test_helper'

class CartTest < ActiveSupport::TestCase


  test 'add unique product' do
  	carts(:one).add_product(products(:ruby).id,products(:ruby).price)
  	assert_equal 1, carts(:one).line_items.size
  end
  
  test 'add duplicate product' do
    ruby_product = products(:ruby)
  	cart = Cart.create

    2.times do 
    	line_item = cart.add_product(ruby_product.id, ruby_product.price)
      line_item.save!
    end

  	assert_equal 1, cart.line_items.size

  end

end
