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

ActiveRecord::Schema[8.1].define(version: 2016_01_30_185001) do
  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "author_id"
    t.string "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ud_sync_operations", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_id"
    t.string "external_id", null: false
    t.string "owner_id"
    t.string "entity_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
