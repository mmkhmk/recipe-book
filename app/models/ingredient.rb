class Ingredient < ActiveRecord::Base
	belongs_to :recipe

  validates :name, presence: true
  validates :quantity, presence: true
end