class DropUniqConstraintUserEmail < ActiveRecord::Migration[5.1]
  def up
    remove_index :users, name: "email"
    add_index :users, :email, name: "email", using: :btree
  end
end
