require 'pry'
# Imported contacts from a CSV files
class ContactsController < ApplicationController
  before_action :authenticate_user!
  def index
    @contacts = Contact.all
  end

  def new
    @contact = Contact.new
  end

  def import_data
    binding.pry
    # Check if a file was uploaded
    if params[:file].present?
      # Save the uploaded file to the public folder
      file_path = Rails.root.join('public', 'uploads', params[:file].original_filename)
      File.open(file_path, 'wb') do |file|
        file.write(params[:file].read)
      end

      # Enqueue the background job to process the uploaded file
      ImportDataJob.perform_later(file_path.to_s)

      flash[:success] = 'File uploaded and processing has started'
    else
      flash[:error] = 'Please select a file to upload'
    end
    render contacts_path
  end
end
