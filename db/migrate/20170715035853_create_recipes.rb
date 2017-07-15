class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.integer :cook_time, null: false
      t.integer :serving_for
      t.string :cook_point
      t.references :tag
      t.timestamps
    end
  end
end
