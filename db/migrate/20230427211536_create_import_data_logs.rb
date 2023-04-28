class CreateImportDataLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :import_data_logs do |t|
      t.string :job_id
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.text :message_errors
      t.string :file_path

      t.timestamps
    end
  end
end
