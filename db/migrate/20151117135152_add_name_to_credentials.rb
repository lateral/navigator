class AddNameToCredentials < ActiveRecord::Migration
  def change
    add_column :credentials, :name, :string
  end
end
