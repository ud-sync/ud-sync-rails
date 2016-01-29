class CreateUdSyncTables < ActiveRecord::Migration
  def change
    create_table :ud_sync_operations do |t|
      t.string  :name,         null: false
      t.string  :record_id,    null: false
      t.integer :user_id
      t.integer :author_id
      t.string  :entity_name,  null: false
      t.timestamps
    end
  end
end
