# frozen_string_literal: true
require 'csv'
require 'pry'

# Loads file and information into Contact
class ImportDataJob
  include Sidekiq::Worker
  include ContactsHelper

  def perform(user_id, params)
    logs = []
    CSV.foreach(params['file'], headers: true) do |row|
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
      logs.push(message) and next unless status

      # Day of Birth
      status, message = validate_dob(row[dob_row]).values_at(:status, :message)
      new_contact.dob = row[dob_row] if status
      logs.push(message) and next unless status

      # Phone
      status, message = validate_phone(row[phone_row]).values_at(:status, :message)
      new_contact.phone = row[phone_row] if status
      logs.push(message) and next unless status

      # Address
      status, message = validate_address(row[address_row]).values_at(:status, :message)
      new_contact.address = row[address_row] if status
      logs.push(message) and next unless status

      # Email
      status, message = validate_email(row[email_row]).values_at(:status, :message)
      if status
        new_email = row[email_row]
        repeteaded_email = Contact.find_by(user_id: user_id, email: new_email).present?
        new_contact.email = row[email_row]
      else
        logs.push(message) and next
      end

      # Credit Card
      status, message, cc_network = validate_cc_number(row[cc_number_row]).values_at(:status, :message, :cc_network)
      if status
        new_contact.cc_number = row[cc_number_row]
        new_contact.cc_network = cc_network
      else
        logs.push(message)
      end
      new_contact.user_id = user_id

      logs.push('Success') if new_contact.save
    end
  end
end
