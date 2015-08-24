class Order < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	

	def payment_types
	 	[ I18n.t('orders.payment_types.check'), I18n.t('orders.payment_types.credit_card'), I18n.t('orders.payment_types.purchase_order') ]
	end	
	
	validates :name, :address, :email, presence: true

	# validates :pay_type, inclusion: PAYMENT_TYPES

	after_update :send_shipped_products_email

	def add_line_items_from_cart(cart) 
		cart.line_items.each do |item|
      		item.cart_id = nil
      		line_items << item
		end 
	end

	def send_shipped_products_email
		 if self.ship_date_changed?
		 	OrderNotifier.shipped(self).deliver
		 end	    

	
	end	

end
