class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :favorites
  has_many :micropostings, through: :favorites, source: :micropost
  has_many :reverses_of_favorite, class_name: 'Favorite', foreign_key: 'micropost_id'
  has_many :microposters, through: :reverses_of_favorite, source: :user

  def micropost(other_user)
    unless self == other_user
      self.favorites.find_or_create_by(micropost_id: other_user.id)
    end
  end

  def unmicropost(other_user)
    favorite = self.favorites.find_by(micropost_id: other_user.id)
    favorite.destroy if favorite
  end

  def microposting?(other_user)
    self.micropostings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.microposting_ids + [self.id])
  end
end
