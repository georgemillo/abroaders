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

ActiveRecord::Schema.define(version: 20170817194900) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "monthly_spending_usd"
    t.string "onboarding_state", default: "home_airports", null: false
    t.string "promo_code"
    t.boolean "test", default: false, null: false
    t.string "phone_number"
    t.string "phone_number_normalized"
    t.string "fb_token"
    t.string "phone_number_us_normalized"
    t.boolean "aw_in_survey", default: false, null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["fb_token"], name: "index_accounts_on_fb_token"
    t.index ["onboarding_state"], name: "index_accounts_on_onboarding_state"
    t.index ["phone_number_normalized"], name: "index_accounts_on_phone_number_normalized"
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "accounts_home_airports", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "airport_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "airport_id"], name: "index_accounts_home_airports_on_account_id_and_airport_id", unique: true
    t.index ["account_id"], name: "index_accounts_home_airports_on_account_id"
    t.index ["airport_id"], name: "index_accounts_home_airports_on_airport_id"
  end

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "avatar_file_name", null: false
    t.string "avatar_content_type", null: false
    t.integer "avatar_file_size", null: false
    t.datetime "avatar_updated_at", null: false
    t.string "last_name", null: false
    t.text "bio"
    t.string "job_title"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "award_wallet_accounts", id: :serial, force: :cascade do |t|
    t.integer "award_wallet_owner_id", null: false
    t.integer "aw_id", null: false
    t.string "display_name", null: false
    t.string "kind", null: false
    t.string "login", null: false
    t.integer "balance_raw", null: false
    t.integer "error_code", null: false
    t.string "error_message"
    t.string "last_detected_change"
    t.datetime "expiration_date"
    t.datetime "last_retrieve_date"
    t.datetime "last_change_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aw_id"], name: "index_award_wallet_accounts_on_aw_id"
    t.index ["award_wallet_owner_id"], name: "index_award_wallet_accounts_on_award_wallet_owner_id"
  end

  create_table "award_wallet_owners", id: :serial, force: :cascade do |t|
    t.integer "award_wallet_user_id", null: false
    t.string "name", null: false
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["award_wallet_user_id", "name"], name: "index_award_wallet_owners_on_award_wallet_user_id_and_name", unique: true
    t.index ["award_wallet_user_id"], name: "index_award_wallet_owners_on_award_wallet_user_id"
    t.index ["name"], name: "index_award_wallet_owners_on_name"
    t.index ["person_id"], name: "index_award_wallet_owners_on_person_id"
  end

  create_table "award_wallet_users", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "aw_id", null: false
    t.boolean "loaded", default: false, null: false
    t.integer "agent_id"
    t.string "full_name"
    t.string "user_name"
    t.string "status"
    t.string "email"
    t.string "forwarding_email"
    t.string "access_level"
    t.string "accounts_access_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "syncing", default: false, null: false
    t.index ["account_id"], name: "index_award_wallet_users_on_account_id"
    t.index ["aw_id"], name: "index_award_wallet_users_on_aw_id"
  end

  create_table "balances", id: :serial, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "currency_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_balances_on_currency_id"
    t.index ["person_id", "currency_id"], name: "index_balances_on_person_id_and_currency_id"
    t.index ["person_id"], name: "index_balances_on_person_id"
  end

  create_table "card_products", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "annual_fee_cents", null: false
    t.boolean "shown_on_survey", default: true, null: false
    t.integer "currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bank_id", null: false
    t.string "wallaby_id"
    t.string "image_file_name", null: false
    t.string "image_content_type", null: false
    t.integer "image_file_size", null: false
    t.datetime "image_updated_at", null: false
    t.boolean "personal", null: false
    t.string "network", null: false
    t.string "type", null: false
    t.index ["bank_id"], name: "index_card_products_on_bank_id"
    t.index ["currency_id"], name: "index_card_products_on_currency_id"
    t.index ["wallaby_id"], name: "index_card_products_on_wallaby_id"
  end

  create_table "cards", id: :serial, force: :cascade do |t|
    t.integer "card_product_id", null: false
    t.integer "person_id", null: false
    t.integer "offer_id"
    t.datetime "recommended_at"
    t.date "applied_on"
    t.date "opened_on"
    t.date "closed_on"
    t.string "decline_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "clicked_at"
    t.datetime "declined_at"
    t.datetime "denied_at"
    t.datetime "nudged_at"
    t.datetime "called_at"
    t.datetime "redenied_at"
    t.datetime "seen_at"
    t.datetime "expired_at"
    t.integer "recommended_by_id"
    t.integer "recommendation_request_id"
    t.index ["recommended_at"], name: "index_cards_on_recommended_at"
    t.index ["seen_at"], name: "index_cards_on_seen_at"
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "award_wallet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "shown_on_survey", default: true, null: false
    t.string "type", null: false
    t.string "alliance_name", null: false
    t.index ["award_wallet_id"], name: "index_currencies_on_award_wallet_id", unique: true
    t.index ["name"], name: "index_currencies_on_name", unique: true
    t.index ["type"], name: "index_currencies_on_type"
  end

  create_table "destinations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.integer "parent_id"
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.index ["code", "type"], name: "index_destinations_on_code_and_type", unique: true
    t.index ["name"], name: "index_destinations_on_name"
    t.index ["parent_id"], name: "index_destinations_on_parent_id"
    t.index ["type"], name: "index_destinations_on_type"
  end

  create_table "flights", id: :serial, force: :cascade do |t|
    t.integer "travel_plan_id", null: false
    t.integer "position", limit: 2, default: 0, null: false
    t.integer "from_id", null: false
    t.integer "to_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id"], name: "index_flights_on_from_id"
    t.index ["to_id"], name: "index_flights_on_to_id"
    t.index ["travel_plan_id", "position"], name: "index_flights_on_travel_plan_id_and_position", unique: true
    t.index ["travel_plan_id"], name: "index_flights_on_travel_plan_id"
  end

  create_table "interest_regions", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "region_id"], name: "index_interest_regions_on_account_id_and_region_id", unique: true
    t.index ["account_id"], name: "index_interest_regions_on_account_id"
    t.index ["region_id"], name: "index_interest_regions_on_region_id"
  end

  create_table "offers", id: :serial, force: :cascade do |t|
    t.integer "card_product_id", null: false
    t.integer "points_awarded"
    t.integer "spend"
    t.integer "cost", null: false
    t.integer "days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link", null: false
    t.text "notes"
    t.datetime "last_reviewed_at"
    t.datetime "killed_at"
    t.string "partner", default: "none", null: false
    t.string "condition", null: false
    t.integer "value_cents"
    t.text "user_notes"
    t.integer "cards_count", default: 0, null: false
    t.index ["card_product_id"], name: "index_offers_on_card_product_id"
    t.index ["killed_at"], name: "index_offers_on_killed_at"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "first_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "owner", default: true, null: false
    t.boolean "eligible"
    t.index ["account_id", "first_name"], name: "index_people_on_account_id_and_first_name", unique: true
    t.index ["account_id", "owner"], name: "index_people_on_account_id_and_owner", unique: true
  end

  create_table "recommendation_notes", id: :serial, force: :cascade do |t|
    t.text "content", null: false
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id", null: false
    t.index ["account_id"], name: "index_recommendation_notes_on_account_id"
    t.index ["admin_id"], name: "index_recommendation_notes_on_admin_id"
  end

  create_table "recommendation_requests", id: :serial, force: :cascade do |t|
    t.integer "person_id", null: false
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_recommendation_requests_on_person_id"
    t.index ["resolved_at"], name: "index_recommendation_requests_on_resolved_at"
  end

  create_table "spending_infos", id: :serial, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "credit_score", null: false
    t.boolean "will_apply_for_loan", default: false, null: false
    t.integer "business_spending_usd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "has_business", null: false
    t.index ["person_id"], name: "index_spending_infos_on_person_id", unique: true
  end

  create_table "travel_plans", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "no_of_passengers", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "further_information"
    t.date "depart_on", null: false
    t.date "return_on"
    t.boolean "accepts_economy", default: false, null: false
    t.boolean "accepts_premium_economy", default: false, null: false
    t.boolean "accepts_business_class", default: false, null: false
    t.boolean "accepts_first_class", default: false, null: false
    t.string "type", null: false
    t.index ["account_id"], name: "index_travel_plans_on_account_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "monthly_spending_usd"
    t.string "onboarding_state", default: "home_airports", null: false
    t.string "promo_code"
    t.boolean "test", default: false, null: false
    t.string "phone_number"
    t.string "phone_number_normalized"
    t.string "fb_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["fb_token"], name: "index_users_on_fb_token"
    t.index ["onboarding_state"], name: "index_users_on_onboarding_state"
    t.index ["phone_number_normalized"], name: "index_users_on_phone_number_normalized"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts_home_airports", "accounts", on_delete: :cascade
  add_foreign_key "accounts_home_airports", "destinations", column: "airport_id", on_delete: :restrict
  add_foreign_key "award_wallet_accounts", "award_wallet_owners", on_delete: :cascade
  add_foreign_key "award_wallet_owners", "award_wallet_users", on_delete: :cascade
  add_foreign_key "award_wallet_owners", "people", on_delete: :nullify
  add_foreign_key "award_wallet_users", "accounts", on_delete: :cascade
  add_foreign_key "balances", "currencies", on_delete: :cascade
  add_foreign_key "balances", "people", on_delete: :cascade
  add_foreign_key "card_products", "currencies", on_delete: :restrict
  add_foreign_key "cards", "admins", column: "recommended_by_id", on_delete: :nullify
  add_foreign_key "cards", "card_products", on_delete: :restrict
  add_foreign_key "cards", "offers", on_delete: :cascade
  add_foreign_key "cards", "people", on_delete: :cascade
  add_foreign_key "cards", "recommendation_requests", on_delete: :nullify
  add_foreign_key "destinations", "destinations", column: "parent_id", on_delete: :restrict
  add_foreign_key "flights", "destinations", column: "from_id", on_delete: :restrict
  add_foreign_key "flights", "destinations", column: "to_id", on_delete: :restrict
  add_foreign_key "flights", "travel_plans", on_delete: :cascade
  add_foreign_key "interest_regions", "accounts", on_delete: :cascade
  add_foreign_key "interest_regions", "destinations", column: "region_id", on_delete: :restrict
  add_foreign_key "offers", "card_products", on_delete: :cascade
  add_foreign_key "people", "accounts", on_delete: :cascade
  add_foreign_key "recommendation_notes", "accounts", on_delete: :cascade
  add_foreign_key "recommendation_notes", "admins", on_delete: :restrict
  add_foreign_key "recommendation_requests", "people", on_delete: :cascade
  add_foreign_key "spending_infos", "people", on_delete: :cascade
  add_foreign_key "travel_plans", "accounts", on_delete: :cascade
end
