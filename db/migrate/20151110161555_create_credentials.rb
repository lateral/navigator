class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.string :key
      t.string :url_hash
      t.string :slug
      t.string :username
      t.string :password

      t.timestamps null: false
    end
  end
end
