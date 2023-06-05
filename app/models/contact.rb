# frozen_string_literal: true

class Contact < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :dob, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  validates :cc_number, presence: true
  validates :cc_network, presence: true
  validates :email, presence: true
  validates :user_id, presence: true

  def hidden_cc_number
    cc_size = cc_number.length
    'X' * (cc_size - 4) + " #{cc_number[cc_size - 4..]}"
  end
end
