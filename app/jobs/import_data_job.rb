# frozen_string_literal: true

require 'csv'
require 'pry'

# Loads file and information into Contact
class ImportDataJob
  include Sidekiq::Worker
  include ContactsHelper

  def perform(user_id, params, job_id)
    logs = []
    import_data_log = create_import_data(params['file'], user_id, job_id)
    finished = false # at least one contact was created
    CSV.foreach(params['file'], headers: true, encoding: "UTF-8").with_index(2) do |row, row_number|
      # Mapped row names
      name_row = params['name']
      dob_row = params['dob']
      phone_row = params['phone']
      address_row = params['address']
      cc_number_row = params['cc_number']
      email_row = params['email']
      new_contact = Contact.new

      # Name
      status, message = validate_name(row[name_row]).values_at(:status, :message)
      new_contact.name = row[name_row] if status
      unless status
        logs.push({ row_id: row_number, error_message: message, type: :name, value: row[name_row] })
        next
      end

      # Day of Birth
      status, message = validate_dob(row[dob_row]).values_at(:status, :message)
      new_contact.dob = row[dob_row] if status
      unless status
        logs.push({ row_id: row_number, error_message: message, type: :dob, value: row[dob_row] })
        next
      end

      # Phone
      status, message = validate_phone(row[phone_row]).values_at(:status, :message)
      new_contact.phone = row[phone_row] if status
      unless status
        logs.push({ row_id: row_number, error_message: message, type: :phone, value: row[phone_row] })
        next
      end

      # Address
      status, message = validate_address(row[address_row]).values_at(:status, :message)
      new_contact.address = row[address_row] if status
      unless status
        logs.push({ row_id: row_number, error_message: message, type: :address, value: row[address_row] })
        next
      end

      # Email
      status, message = validate_email(row[email_row]).values_at(:status, :message)
      if status
        new_email = row[email_row]
        if Contact.find_by(user_id: user_id, email: new_email).present?
          logs.push({ row_id: row_number, error_message: 'Repeteated email', type: :email, value: row[email_row] })
          next
        end
        new_contact.email = row[email_row]
      else
        logs.push({ row_id: row_number, error_message: message, type: :email, value: row[email_row] })
        next
      end

      # Credit Card
      status, message, cc_network = validate_cc_number(row[cc_number_row]).values_at(:status, :message, :cc_network)
      if status
        new_contact.cc_number = row[cc_number_row]
        new_contact.cc_network = cc_network
      else
        logs.push({ row_id: row_number, error_message: message, type: :cc_number, value: row[cc_number_row] })
        next
      end
      new_contact.user_id = user_id
      finished = true if new_contact.save
    end

    ActiveRecord::Base.transaction do
      if finished && logs.present?
        # At least one was added
        import_data_log.update(message_errors: logs, status: :finished)
      else
        # Not a single contact was added
        import_data_log.update(message_errors: logs, status: :failed)
      end
    end
  end

  def create_import_data(filename, user_id, job_id)
    ActiveRecord::Base.transaction do
      return ImportDataLog.create({ file_path: filename, user_id: user_id, job_id: job_id, status: 'processing' })
    end
  end
end
