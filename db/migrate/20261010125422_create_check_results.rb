class CreateCheckResults < ActiveRecord::Migration[8.1]
  def change
    create_table :check_results do |t|
      t.references :site, null: false, foreign_key: true
      t.integer :status_code
      t.integer :response_time_ms
      t.boolean :successful, default: false, null: false
      t.string :error_message

      t.timestamps
    end
  end
end
