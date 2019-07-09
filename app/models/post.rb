class Post < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :likes
  has_many :users, through: :likes
end
