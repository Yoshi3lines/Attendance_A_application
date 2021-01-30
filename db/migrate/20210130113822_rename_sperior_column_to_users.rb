class RenameSperiorColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :sperior, :superior
  end
end
