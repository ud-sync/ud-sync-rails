class CreateUdSyncTables < ActiveRecord::Migration[4.2]
  def change
    create_table :ud_sync_operations, if_not_exists: true do |t|
      t.string :name,         null: false
      t.string :record_id
      t.string :external_id,  null: false
      t.string :owner_id
      t.string :entity_name,  null: false
      t.timestamps
    end
  end
end

