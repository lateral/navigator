class AddPasswordProtectedToCredentials < ActiveRecord::Migration
  def change
    add_column :credentials, :password_protected, :boolean, null: false, default: false
  end
end
