# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_16_050000) do

  create_table "domain_names", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organization_domain_names", force: :cascade do |t|
    t.bigint "domain_name_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_name_id"], name: "index_organization_domain_names_on_domain_name_id"
    t.index ["organization_id", "domain_name_id"], name: "idx_organization_domain_names_on_organization_and_domain_name", unique: true
  end

  create_table "organization_tags", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "tag_id"], name: "index_organization_tags_on_organization_id_and_tag_id", unique: true
    t.index ["tag_id"], name: "index_organization_tags_on_tag_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "details"
    t.string "external_id", null: false
    t.string "name", null: false
    t.boolean "shared_tickets", default: false, null: false
    t.string "url", limit: 1024, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "ticket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_ticket_tags_on_tag_id"
    t.index ["ticket_id", "tag_id"], name: "index_ticket_tags_on_ticket_id_and_tag_id", unique: true
  end

  create_table "tickets", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "assignee_id"
    t.text "description"
    t.datetime "due_at"
    t.string "external_id", null: false
    t.boolean "has_incidents", default: false, null: false
    t.bigint "organization_id"
    t.integer "priority", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "subject", null: false
    t.bigint "submitter_id"
    t.integer "ticket_type", default: 0
    t.string "url", limit: 1024, null: false
    t.integer "via", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject"], name: "index_tickets_on_subject"
  end

  create_table "user_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["user_id", "tag_id"], name: "index_user_tags_on_user_id_and_tag_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "alias"
    t.string "email"
    t.string "external_id", null: false
    t.datetime "last_login_at", null: false
    t.string "locale"
    t.string "name", null: false
    t.bigint "organization_id"
    t.string "phone", null: false
    t.integer "role", default: 0, null: false
    t.boolean "shared", default: false, null: false
    t.string "signature", limit: 512, null: false
    t.boolean "suspended", default: false, null: false
    t.string "timezone"
    t.string "url", limit: 1024, null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name"
  end

end
