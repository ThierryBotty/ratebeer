class User < ApplicationRecord
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password
  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /.*(([A-Z].*\d)|(\d.*[A-Z])).*/,
                                 message:
                                 "needs at least a capital letter and a digit" }
end
