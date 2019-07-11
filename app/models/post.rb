class Post < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_one_attached :avatar
  attr_accessor :city_id
  validates :location_id, presence: true
  validates :avatar, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg']}
  
end
