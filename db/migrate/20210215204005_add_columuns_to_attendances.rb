class AddColumunsToAttendances < ActiveRecord::Migration[5.1]
  def change
    # 残業申請モーダル
    add_column :attendances, :overtime_finished_at, :datetime
    add_column :attendances, :tomorrow, :boolean, default: false
    add_column :attendances, :overtime_work, :string
    # どの上長に残業申請を出しているか
    add_column :attendances, :indicater_check, :string
    # 申請内容を承認したのか、どうか？
    add_column :attendances, :indicater_check_anser, :string
  end
end
