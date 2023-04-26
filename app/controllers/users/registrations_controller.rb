# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      redirect_to root_path
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new
    end
  end

  def update
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
