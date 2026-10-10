class CreateSites < ActiveRecord::Migration[8.1]
  def change
    create_table :sites do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :interval_seconds, default: 60, null: false
      t.integer :expected_status, default: 200, null: false
      t.string :status, default: "pending", null: false
      t.datetime :last_checked_at

      t.timestamps
    end

    add_index :sites, :status
    add_index :sites, :last_checked_at
  end
end
