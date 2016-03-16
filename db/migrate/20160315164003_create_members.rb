class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |table|
      table.integer :user_id, null: false
      table.integer :event_id, null: false
      table.boolean :creator, null: false
    end
  end
end
