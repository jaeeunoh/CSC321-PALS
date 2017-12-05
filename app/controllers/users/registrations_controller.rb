class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @dogs = Interest.dog_interests
    @cats = Interest.cat_interests
    @other = Interest.other_interests
    super
  end

  # POST /resource
  def create
    super
    if params[:interests] then
      params[:interests].each do |int| 
        @interest = Interest.find_by name: int
        @user.interests << @interest
      end
    end
    if params[:dog_interests] then
      params[:dog_interests].each do |int|
        @interest = Interest.find_by name: "Dog " + int.downcase
        @user.interests << @interest
      end
    end
    if params[:cats] then
      params[:cat_interests].each do |int|
        @interest = Interest.find_by name: "Cat " + int.downcase
        @user.interests << @interest
      end
    end
    if params[:other] then
      @int_params = params[:other_interests].split(',')
      @int_params.each do |int|
        Interest.create!(name: int.strip.capitalize)
        @interest = Interest.find_by name: int.strip.capitalize
        @user.interests << @interest
      end
    end
  end

  # GET /resource/edit
  def edit
    if current_user != params[:id]
      flash[:warning] = "Illegal action. You do not have permission."
      redirect_to root_path
    else
      super
    end
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    user_path(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    user_path(resource)
  end
end
