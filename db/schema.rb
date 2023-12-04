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

ActiveRecord::Schema[7.1].define(version: 2023_12_01_183748) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.text "name"
    t.integer "quantity"
    t.float "unit_price"
    t.float "total_price"
    t.bigint "shopping_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopping_id"], name: "index_items_on_shopping_id"
  end

  create_table "shoppings", force: :cascade do |t|
    t.date "date_shopping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total_price"
    t.string "status"
  end

  add_foreign_key "items", "shoppings"
end
