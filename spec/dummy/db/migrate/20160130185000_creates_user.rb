class CreatesUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :uuid
      t.timestamps
    end
  end
end

