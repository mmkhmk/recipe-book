class Step < ActiveRecord::Base
	belongs_to :recipe

  validates :description, presence: true
end