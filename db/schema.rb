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

ActiveRecord::Schema.define(:version => 20110628161353) do

  create_table "agent_prices", :force => true do |t|
    t.integer  "spot_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agents", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "disabled",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "business_contact"
    t.string   "business_phone"
    t.string   "finance_contact"
    t.string   "finance_phone"
  end

  add_index "agents", ["name"], :name => "index_agents_on_name", :unique => true

  create_table "cities", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "pinyin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["code"], :name => "index_cities_on_code", :unique => true
  add_index "cities", ["name"], :name => "index_cities_on_name", :unique => true

  create_table "cities_spots", :id => false, :force => true do |t|
    t.integer "city_id"
    t.integer "spot_id"
  end

  create_table "individual_rates", :force => true do |t|
    t.integer  "child_sale_price"
    t.integer  "child_purchase_price"
    t.integer  "adult_sale_price"
    t.integer  "adult_purchase_price"
    t.integer  "agent_price_id"
    t.integer  "season_id"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_groups", :force => true do |t|
    t.string  "name"
    t.string  "category"
    t.integer "seq"
  end

  create_table "menus", :force => true do |t|
    t.string  "name"
    t.string  "url"
    t.integer "menu_group_id"
    t.integer "seq"
  end

  create_table "menus_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "menu_id"
  end

  create_table "public_rates", :force => true do |t|
    t.integer  "season_id"
    t.integer  "adult_price"
    t.integer  "child_price"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_histories", :force => true do |t|
    t.date     "purchase_date"
    t.string   "user"
    t.integer  "agent_id"
    t.integer  "spot_id"
    t.integer  "price"
    t.boolean  "is_individual"
    t.string   "payment_method"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reservations", :force => true do |t|
    t.string   "no"
    t.integer  "agent_id"
    t.integer  "spot_id"
    t.string   "ticket_name"
    t.integer  "child_sale_price"
    t.integer  "child_purchase_price"
    t.integer  "adult_sale_price"
    t.integer  "adult_purchase_price"
    t.integer  "adult_price"
    t.integer  "child_price"
    t.integer  "child_ticket_number",      :default => 0
    t.integer  "adult_ticket_number",      :default => 1
    t.date     "date"
    t.string   "type"
    t.string   "status"
    t.string   "contact"
    t.string   "phone"
    t.integer  "total_price"
    t.integer  "total_purchase_price"
    t.boolean  "paid"
    t.integer  "adult_true_ticket_number"
    t.integer  "child_true_ticket_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_method"
    t.integer  "book_price"
    t.integer  "book_purchase_price"
    t.string   "group_no"
    t.integer  "purchase_history_id"
  end

  create_table "rfps", :force => true do |t|
    t.integer  "agent_id"
    t.integer  "spot_id"
    t.integer  "agent_price_id"
    t.string   "status",                    :limit => 1, :default => "a"
    t.boolean  "from_spot",                              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "team_payment_method"
    t.string   "individual_payment_method"
  end

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.integer "roleable_id"
    t.string  "roleable_type"
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.integer  "spot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spots", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "disabled",         :default => false, :null => false
    t.string   "address"
    t.text     "traffic"
    t.string   "business_contact"
    t.string   "business_phone"
    t.string   "finance_contact"
    t.string   "finance_phone"
  end

  add_index "spots", ["code"], :name => "index_spots_on_code", :unique => true
  add_index "spots", ["name"], :name => "index_spots_on_name", :unique => true

  create_table "team_rates", :force => true do |t|
    t.integer  "adult_price"
    t.integer  "child_price"
    t.integer  "agent_price_id"
    t.integer  "season_id"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.string   "name"
    t.integer  "spot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timespans", :force => true do |t|
    t.date     "from_date"
    t.date     "to_date"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "type"
    t.integer  "spot_id"
    t.integer  "agent_id"
    t.integer  "role_id"
    t.boolean  "deleted",       :default => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
