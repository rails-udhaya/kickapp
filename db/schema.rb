# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150416000454) do

  create_table "creators", :force => true do |t|
    t.string   "reference_creator_id"
    t.string   "name"
    t.string   "slug"
    t.string   "biography"
    t.string   "user_updated_at"
    t.string   "user_created_at"
    t.text     "backed_projects"
    t.text     "started_projects"
    t.text     "location"
    t.text     "urls"
    t.text     "avatar"
    t.text     "category_wheel"
    t.text     "kickstart_creator_url"
    t.integer  "started_projects_count"
    t.integer  "unanswered_surveys_count"
    t.integer  "backed_projects_count"
    t.integer  "created_projects_count"
    t.integer  "unread_messages_count"
    t.boolean  "notifiy"
    t.boolean  "social"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "pledged_backers", :force => true do |t|
    t.integer  "pledged"
    t.integer  "backers_count"
    t.integer  "project_id"
    t.datetime "pledges_created_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "reference_project_id"
    t.string   "name"
    t.string   "slug"
    t.string   "blurb"
    t.string   "state"
    t.string   "currency"
    t.string   "currency_symbol"
    t.string   "country"
    t.string   "country_short_name"
    t.string   "country_long_name"
    t.string   "rewards"
    t.string   "launched_at"
    t.string   "project_updated_at"
    t.string   "deadline"
    t.string   "state_changed_at"
    t.text     "photo"
    t.text     "video"
    t.text     "embed"
    t.text     "location"
    t.text     "friends"
    t.text     "urls"
    t.text     "kickstart_project_url"
    t.integer  "creator_id"
    t.integer  "comments_count"
    t.integer  "updates_count"
    t.float    "goal"
    t.boolean  "is_started"
    t.boolean  "is_backing"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

end
