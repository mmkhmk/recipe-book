class Recipe < ActiveRecord::Base
  has_one :picture, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  belongs_to :tag
  accepts_nested_attributes_for :picture, allow_destroy: true
  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :steps, allow_destroy: true
  accepts_nested_attributes_for :tag

  validates :title, presence: true
  validates :description, presence: true
  validates :cook_time, presence: true
  validates :serving_for, presence: true
  validates :cook_point, presence: true

  scope :by_tag, ->(tag_id) { where(tag: tag_id) }

  class << self
    def search(params)
      if params[:tag].present?
        by_tag(params[:tag])
      else
        all
      end
    end
  end

  def medium_image
    picture.medium
  end

  def small_image
    picture.small
  end

  def related_recipes
    self.class.where(tag_id: tag.id).where.not(id: id)
  end
end