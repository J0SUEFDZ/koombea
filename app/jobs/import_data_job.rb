require 'csv'

class ImportDataJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      # Do something with each row of data, such as create a new record in the database
      # Example: User.create(name: row['Name'], email: row['Email'], phone: row['Phone'])
    end
  end
end
