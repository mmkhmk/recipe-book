class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
    	t.references :recipe
    	t.string :name, null: false
    	t.string :quantity, null: false
    end
  end
end
