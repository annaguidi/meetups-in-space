class AddUniqueToMembers < ActiveRecord::Migration
  def change
    add_index "members", ["user_id", "event_id"], name: "index_users_on_uid_and_evid", unique: true, using: :btree
  end
end
