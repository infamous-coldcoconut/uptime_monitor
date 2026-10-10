# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_10_164320) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "check_results", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.integer "status_code"
    t.integer "response_time_ms"
    t.boolean "successful", default: false, null: false
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_check_results_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.integer "interval_seconds", default: 60, null: false
    t.integer "expected_status", default: 200, null: false
    t.string "status", default: "pending", null: false
    t.datetime "last_checked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_checked_at"], name: "index_sites_on_last_checked_at"
    t.index ["name"], name: "index_sites_on_name", unique: true
    t.index ["status"], name: "index_sites_on_status"
    t.index ["url"], name: "index_sites_on_url", unique: true
  end

  add_foreign_key "check_results", "sites"
end
