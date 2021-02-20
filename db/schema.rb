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

ActiveRecord::Schema.define(version: 20210218210708) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "overtime_finished_at"
    t.boolean "tomorrow", default: false # 翌日のチェックがしてあるのか？
    t.string "overtime_work" # 残業申請モーダルの申請内容
    t.string "indicater_check" # どの上長に残業申請しているか？
    t.string "indicater_check_anser" # 申請した内容を承認したか？　----ここまでが１回目のカラム追加
    t.integer "indicater_reply" # 指示者確認
    t.boolean "change", default: false # 変更
    t.boolean "verification", default: false # 確認　-----ここまでが２回目のカラム追加
    t.string "indicater_check_edit" # どの上長に申請しているか
    t.integer "indicater_reply_edit" # 指示者確認の「なし」「承認」「否認」「申請中」を入れるカラム
    t.boolean "tomorrow_edit", default: false # 同上
    t.datetime "started_before_at" # 変更前の時間や、編集用の出勤と退勤の時間 ----ここから
    t.datetime "started_edit_at"
    t.datetime "finished_before_at"
    t.datetime "finished_edit_at" # -----ここまで
    t.boolean "change_edit", default: false
    t.string "indicater_check_edit_anser" # ----ここまでが３回目のカラム追加
    t.date "month_approval" # 承認申請月
    t.string "indicater_check_month" # どの上長に申請したか？
    t.integer "indicater_reply_month" # 指示者確認(月単位)
    t.boolean "change_month", default: false # モーダルの変更ボタン
    t.string "indicater_check_month_anser" # お知らせモーダルのメッセージ ----ここまでが４回目のカラム追加
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.text "information"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.datetime "basic_time", default: "2021-02-08 23:00:00"
    t.datetime "work_time", default: "2021-02-08 22:30:00"
    t.time "designated_work_start_time", default: "2000-01-01 00:00:00"
    t.time "designated_work_end_time", default: "2000-01-01 09:00:00"
    t.string "employee_number"
    t.string "uid"
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
