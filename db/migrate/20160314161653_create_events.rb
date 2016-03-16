class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |table|
      table.string :name, null: false
      table.string :description, null: false
      table.string :location, null: false

      table.timestamps null: false
    end
  end
end
