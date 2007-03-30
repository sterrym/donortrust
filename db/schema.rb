# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 1) do

  create_table "cities", :force => true do |t|
    t.column "city_name", :string,  :default => "", :null => false
    t.column "region_id", :integer,                 :null => false
  end

  create_table "contacts", :force => true do |t|
    t.column "first_name",     :string,  :default => "", :null => false
    t.column "last_name",      :string,  :default => "", :null => false
    t.column "phone_number",   :string
    t.column "fax_number",     :string
    t.column "email_address",  :string
    t.column "web_address",    :string
    t.column "department",     :string
    t.column "continent_id",   :integer,                 :null => false
    t.column "region_id",      :integer,                 :null => false
    t.column "city_id",        :integer,                 :null => false
    t.column "address_line_1", :string
    t.column "address_line_2", :string
    t.column "postal_code",    :string
  end

  create_table "continents", :force => true do |t|
    t.column "continent_name", :string, :default => "", :null => false
  end

  create_table "milestone_histories", :force => true do |t|
    t.column "milestone_id", :integer
    t.column "created_at",   :datetime
    t.column "reason",       :text
    t.column "category",     :string
    t.column "description",  :text
    t.column "start",        :date
    t.column "end",          :date
    t.column "status_id",    :integer
  end

  create_table "milestones", :force => true do |t|
    t.column "category",    :string,  :default => "", :null => false
    t.column "description", :text
    t.column "start",       :date,                    :null => false
    t.column "end",         :date,                    :null => false
    t.column "status_id",   :integer,                 :null => false
  end

  create_table "nations", :force => true do |t|
    t.column "nation_name",  :string,  :default => "", :null => false
    t.column "continent_id", :integer,                 :null => false
  end

  create_table "partner_statuses", :force => true do |t|
    t.column "statusType",  :string
    t.column "description", :string
  end

  create_table "partner_types", :force => true do |t|
    t.column "name", :string
  end

  create_table "partners", :force => true do |t|
    t.column "name",              :string
    t.column "description",       :string
    t.column "partner_type_id",   :integer
    t.column "partner_status_id", :integer
  end

  create_table "programs", :force => true do |t|
    t.column "program_name", :string, :default => "", :null => false
    t.column "contact_id",   :string, :default => "", :null => false
  end

  create_table "project_categories", :force => true do |t|
    t.column "description", :text, :default => "", :null => false
  end

  create_table "project_histories", :force => true do |t|
    t.column "project_id",               :integer,  :null => false
    t.column "date",                     :datetime
    t.column "description",              :text
    t.column "total_cost",               :float
    t.column "dollars_spent",            :float
    t.column "expected_completion_date", :datetime
    t.column "start_date",               :datetime
    t.column "end_date",                 :datetime
    t.column "user_id",                  :integer
    t.column "project_status_id",        :integer
    t.column "project_category_id",      :integer
  end

  create_table "project_statuses", :force => true do |t|
    t.column "status_type", :string, :default => "", :null => false
    t.column "description", :text
  end

  create_table "projects", :force => true do |t|
    t.column "program_id",               :integer
    t.column "project_category_id",      :integer
    t.column "name",                     :string,   :default => "", :null => false
    t.column "description",              :text
    t.column "total_cost",               :float
    t.column "dollars_spent",            :float
    t.column "expected_completion_date", :datetime
    t.column "start_date",               :datetime
    t.column "end_date",                 :datetime
    t.column "project_status_id",        :integer
    t.column "contact_id",               :integer
    t.column "village_group_id",         :integer
    t.column "partner_id",               :integer
  end

  create_table "regions", :force => true do |t|
    t.column "region_name", :string,  :default => "", :null => false
    t.column "nation_id",   :integer,                 :null => false
  end

  create_table "statuses", :force => true do |t|
    t.column "category",    :string, :default => "", :null => false
    t.column "description", :text,   :default => "", :null => false
  end

  create_table "village_groups", :force => true do |t|
    t.column "village_group_name", :string,  :default => "", :null => false
    t.column "region_id",          :integer,                 :null => false
  end

  create_table "villages", :force => true do |t|
    t.column "village_name",     :string,  :default => "", :null => false
    t.column "village_group_id", :integer,                 :null => false
  end

end
