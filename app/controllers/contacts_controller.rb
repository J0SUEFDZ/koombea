# frozen_string_literal: true

require 'pry'

# Imported contacts from a CSV files
class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contacts = Contact.page(params[:page]).per(10)
  end

  def import_data
    filename = "/tmp/#{SecureRandom.uuid}-#{params[:file].original_filename}"
    if params[:file].present?
      # Enqueue the background job to process the uploaded file
      File.open(filename, 'wb') do |file|
        file.write(params[:file].read)
      end
      request_params = {
        name: params[:name],
        dob: params[:dob],
        phone: params[:phone],
        address: params[:address],
        cc_number: params[:cc_number],
        email: params[:email],
        file: filename
      }
      secure_job_id = SecureRandom.hex(10)
      ImportDataJob.perform_async(current_user.id, request_params, secure_job_id)
      flash[:success] = "File uploaded and processing has started with id #{secure_job_id}"
    else
      flash[:error] = 'Please select a file to upload'
    end

    redirect_to root_path
  end

  def last_import_log
    @import_job_log = ImportDataLog.where(user_id: current_user.id).last
  end
end
