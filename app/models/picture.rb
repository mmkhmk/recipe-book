class Picture < ActiveRecord::Base
	belongs_to :recipe

  validates :picture, presence: true

  has_attached_file :picture, styles: {
    medium: "400x400>",
    small: "200x200>", thumb: "100x100>"
  },
  storage: :s3,
  s3_protocol: :https,
  s3_permissions: :public_read,
  s3_credentials: "#{Rails.root}/config/s3.yml",
  s3_region: 'ap-northeast-1',
  path: ':class/:attachment/:id/:style.:extension'

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