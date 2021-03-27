class AddLogCheckedToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :log_checked, :string
  end
end
