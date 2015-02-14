class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.text :access_token
      t.datetime :updated_at
      t.datetime :created_at
      t.references :user, index: true
      t.integer :open

      t.timestamps null: false
    end
    add_foreign_key :boxes, :users
  end
end
