class CreateSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :steps do |t|
    	t.references :recipe
    	t.string :description, null: false
    end
  end
end
