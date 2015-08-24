require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
fixtures :products


test "buying a product" do
   LineItem.delete_all
   Order.delete_all
   ruby_book = products(:ruby)

   get "/"
   assert_response :success
   assert_template "index"

   xml_http_request :post, '/line_items', product_id: ruby_book.id
   assert_response :success

   cart = Cart.find(session[:cart_id])
   assert_equal 1, cart.line_items.size
   assert_equal ruby_book, cart.line_items[0].product

   get "/orders/new"
   assert_response :success
   assert_template "new"

   post_via_redirect "/orders",
					 order: { name: "Dave Thomas",
							  address: "123 The Street", 
							  email: "dave@example.com", 
							  pay_type: "Check" }
   assert_response :success 
   assert_template "index"
   cart = Cart.find(session[:cart_id]) 
   assert_equal 0, cart.line_items.size

   orders = Order.all
   assert_equal 1, orders.size
   order = orders[0]
   assert_equal "Dave Thomas", order.name 
   assert_equal "123 The Street", order.address 
   assert_equal "dave@example.com", order.email 
   assert_equal "Check", order.pay_type
   
   assert_equal 1, order.line_items.size
   line_item = order.line_items[0]
   assert_equal ruby_book, line_item.product

   mail = ActionMailer::Base.deliveries.last
   assert_equal ["dave@example.com"], mail.to
   assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value 
   assert_equal "Pragmatic Store Order Confirmation", mail.subject
  
     #login
    user = users(:one)
    get "/login"
    assert_response :success
    post_via_redirect "/login", name: user.name, password: 'secret'
    assert_response :success
    assert_equal '/admin', path

    ship_date_expected = Time.now.to_date
  

    p "/orders/#{order.id}/edit"
    get "/orders/#{order.id}/edit"
    assert_response :success

    put_via_redirect order_path(order), order: {ship_date: ship_date_expected}
    # p "****"
    # p "order: #{order.inspect}"
    
    order = orders.find_by_id(order.id)
    assert_template "show"
    assert_equal ship_date_expected, order.ship_date, 
  
    mail = ActionMailer::Base.deliveries.last
    assert_equal  "Pragmatic Store Order Shipped", mail.subject

  end

  test "should not allow to sensitive data after logout" do
    #login
    user = users(:one)
    get "/login"
    assert_response :success
    post_via_redirect "/login", name: user.name, password: 'secret'
    assert_response :success
    assert_equal '/admin', path
    #logout
    delete "/logout"
    assert_redirected_to "/#{I18n.locale}"
    #Accesing protected data
    get "/products"
    assert_redirected_to "/login?locale=#{I18n.locale}"
     get "/carts/1"
    assert_redirected_to "/login?locale=#{I18n.locale}"
  end  

 



end
