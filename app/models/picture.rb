class Picture < ActiveRecord::Base
	belongs_to :recipe

  validates :picture, presence: true

  has_attached_file :picture, styles: { medium: "400x400>", small: "200x200>", thumb: "100x100>" }

  validates_attachment :picture, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  def medium
    picture.url(:medium)
  end

  def small
    picture.url(:small)
  end

  def thumb
    picture.url(:thumb)
  end
end