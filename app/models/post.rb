class Post < ApplicationRecord
  belongs_to :user
  belongs_to :location
  belongs_to :city
  has_many :likes
  has_many :users, through: :likes
end
