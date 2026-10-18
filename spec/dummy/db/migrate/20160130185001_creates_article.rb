class CreatesArticle < ActiveRecord::Migration[4.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :author_id
      t.string :uuid
      t.timestamps
    end
  end
end

