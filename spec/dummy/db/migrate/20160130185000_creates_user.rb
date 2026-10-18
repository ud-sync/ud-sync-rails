class CreatesUser < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :uuid
      t.timestamps
    end
  end
end

