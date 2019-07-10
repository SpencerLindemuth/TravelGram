class Post < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_one_attached :avatar
  attr_accessor :city_id
end
