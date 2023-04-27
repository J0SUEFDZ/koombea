# frozen_string_literal: true

require 'pry'
# Validates information from form
module ContactsHelper
  def validate_name(name)
    # Names with special characters, except for the minus(-) will be invalid values and cannot be saved.
    valid_name = name.match?(/^[a-zA-ZÀ-ÖØ-öø-ÿ -]+$/)
    { status: valid_name, message: valid_name ? '' : "#{name} contains invalid characters and cannot be saved" }
  end

  def validate_dob(dob)
    # The system will only accept two types of ISO 8601 date formats (%Y%m%d ) and (%F).
    valid_dob = dob.match?(/^\d{4}(-\d{2}){2}$|^\d{8}$/)
    { status: valid_dob, message: valid_dob ? '' : "#{dob} doesn\'t have a valid format" }
  end

  def validate_phone(phone)
    valid_phone = phone.match?(/^\(\+\d{2}\) \d{3}[-\s]?\d{3} \d{2} \d{2}$/)
    { status: valid_phone, message: valid_phone ? '' : "#{phone} doesn\'t have a valid format" }
  end

  def validate_address(address)
    valid_address = !(address.empty? || address.blank?)
    { status: valid_address, message: valid_address ? '' : 'Address is empty' }
  end

  def validate_cc_number(cc_number)
    identify_cc_network(cc_number)
  end

  def validate_email(email)
    valid_email = email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
    { status: valid_email, message: valid_email ? '' : "#{email} doesn\'t have a valid format" }
  end

  private

  def identify_cc_network(cc_number)
    cc_network = ''
    case cc_number
    when /^3[47]\d{13}$/
      cc_network = 'American Express'
      valid_lengths = [15]
    when /^4\d{12}(\d{3})?$/
      cc_network = 'VISA'
      valid_lengths = [13, 16, 19]
    when /^5[1-5]\d{14}$/
      cc_network = 'Mastercard'
      valid_lengths = [16]
    when /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/
      cc_network = 'Diners Club'
      valid_lengths = [14, 15, 16, 17, 18, 19]
    when /^6(?:011|5[0-9]{2})[0-9]{12}$/
      cc_network = 'Discover'
      valid_lengths = [16, 19]
    when /^(?:2131|1800|35\d{3})\d{11}$/
      cc_network = 'JCB'
      valid_lengths = [16, 17, 18, 19]
    else
      cc_network = 'Unknow'
      valid_lengths = []
    end

    if valid_lengths.include?(cc_number.length)
      { status: true, cc_network: cc_network, message: '' }
    else
      { status: false, message: "Card Number #{cc_number} doesn\'t match network or is invalid" }
    end
  end
end
