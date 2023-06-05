# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.date :dob
      t.string :phone
      t.string :address
      t.string :cc_number
      t.string :cc_network
      t.string :email
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
