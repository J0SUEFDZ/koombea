class Contact < ApplicationRecord
  belongs_to :user

  def hidden_cc_number
    cc_size = cc_number.length
    'X' * (cc_size - 4) + " #{cc_number[cc_size - 4..]}"
  end
end
