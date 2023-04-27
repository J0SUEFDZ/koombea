# frozen_string_literal: true

require 'pry'

# Imported contacts from a CSV files
class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    # @contacts = Contact.paginate(page: params[:page], per_page: 1)
    @contacts = Contact.page(params[:page]).per(10)
  end

  def import_data
    uploaded_file = params[:file]&.tempfile&.path
    if uploaded_file.present?
      # Enqueue the background job to process the uploaded file
      request_params = {
        name: params[:name],
        dob: params[:dob],
        phone: params[:phone],
        address: params[:address],
        cc_number: params[:cc_number],
        email: params[:email],
        file: params[:file]&.tempfile&.path
      }
      ImportDataJob.perform_async(current_user.id, request_params)
      flash[:success] = 'File uploaded and processing has started'
    else
      flash[:error] = 'Please select a file to upload'
    end

    # render
  end
end
