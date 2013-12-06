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

ActiveRecord::Schema.define(:version => 20131206034247) do

  create_table "md5_hashes", :force => true do |t|
    t.string   "md5_value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "md5_hashes", ["md5_value"], :name => "index_md5_hashes_on_md5_value", :unique => true

  create_table "plain_texts", :force => true do |t|
    t.string   "plainTextString"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "md5_hash_id"
  end

  add_index "plain_texts", ["plainTextString"], :name => "index_plain_texts_on_plainTextString", :unique => true

  create_table "users", :force => true do |t|
    t.string   "client"
    t.string   "name"
    t.string   "md5_hash_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
