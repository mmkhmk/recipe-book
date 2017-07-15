class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
    	t.references :recipe
    	t.attachment :picture
    end
  end
end
