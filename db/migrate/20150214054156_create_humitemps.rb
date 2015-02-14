class CreateHumitemps < ActiveRecord::Migration
  def change
    create_table :humitemps do |t|
      t.float :humidity
      t.float :temperature
      t.datetime :measured_at
      t.datetime :created_at
      t.references :box, index: true

      t.timestamps null: false
    end
    add_foreign_key :humitemps, :boxes
  end
end
