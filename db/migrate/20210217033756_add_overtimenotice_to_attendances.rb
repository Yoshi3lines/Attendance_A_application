class AddOvertimenoticeToAttendances < ActiveRecord::Migration[5.1]
  def change
    # 指示者確認
    add_column :attendances, :indicater_reply, :integer
    # 変更
    add_column :attendances, :change, :boolean, default: false
    # 確認
    add_column :attendances, :verifacation, :boolean, default: false
  end
end
