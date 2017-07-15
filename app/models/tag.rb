class Tag < ActiveRecord::Base
	has_many :recipes

  validates :name, presence: true

  scope :by_name, ->(name) { where(name: name) }
end