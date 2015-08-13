class ApplicationController < ActionController::Base
  before_action :authorize
  protect_from_forgery with: :exception
  before_action :set_i18n_locale_from_params

  protected
    
    def set_i18n_locale_from_params 
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale]) 
          I18n.locale = params[:locale]
        else
          flash.now[:notice] =
            "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end 
      end
    end


    def default_url_options
      { locale: I18n.locale }
    end

    def authorize
        if request.format == Mime::HTML
          unless User.find_by(id: session[:user_id])
            if User.count.zero?
              flash[:notice] = "Create an administrator account"
              redirect_to :controller => 'admin', :action => 'login'
            else  
              redirect_to login_url, notice: "Please log in"
            end  
          end
        else  
          authenticate_or_request_with_http_basic do |username, password|
             user = User.find_by_name(username)
             user and user.authenticate(password)
          end  
        end


    end
end
