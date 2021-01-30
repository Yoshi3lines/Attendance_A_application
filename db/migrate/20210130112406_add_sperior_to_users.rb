class AddSperiorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sperior, :boolean, default: false
  end
end
