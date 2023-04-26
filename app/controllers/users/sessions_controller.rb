# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    redirect_to root_path
  end

  def destroy
    super
    flash[:notice] = "You have been signed out."
  end
end
