# frozen_string_literal: true

class ImportDataLog < ApplicationRecord
  belongs_to :user
  enum status: { on_hold: 0, processing: 1, failed: 2, finished: 3 }, _default: 'on_hold'
  has_one_attached :csv_file
  serialize :message_errors, Array
end
