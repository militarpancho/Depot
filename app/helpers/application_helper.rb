module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end

  def currency_to_locale(price)
  	if I18n.locale == :es
  		price = price*0.897
  	end	
  	number_to_currency price
  end	


end