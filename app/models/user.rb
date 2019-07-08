class User < ApplicationRecord
  has_many :likes
  has_many :posts, through: :likes
  has_many :posts
  has_many :locations, through: :posts
  has_many :cities, through: :posts
  
end
