# frozen_string_literal: true

class ImportDataLog < ApplicationRecord
  belongs_to :user
  enum status: %i[on_hold processing failed finished], _default: 'on_hold'
  serialize :message_errors, Array
end
