class User < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :posts, through: :likes
  has_many :posts, dependent: :destroy
  has_many :locations, through: :posts
  has_many :cities, through: :posts
  validates :username, :uniqueness => true #{:scope => :password}
  has_secure_password
end
