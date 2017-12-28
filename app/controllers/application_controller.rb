class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:interests, :phone, :dob, :name, :email, :password, :password_confirmation, :username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :phone, :dob, :name, :email, :password, :password_confirmation, :interests, :avatar, :bio])
  end
  
  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end
  
  def application
    @current_user = current_user
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      (request.user_agent =~ /(iPhone|iPod|Android|Mobile|webOS)/) && (request.user_agent !~ /iPad/)
    end
  end
  helper_method :mobile_device?
end
