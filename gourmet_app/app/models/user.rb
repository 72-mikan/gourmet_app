class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorites, dependent: :destroy

  def favorited_by?(user, shop_id)
    self.favorites.exists?(user_id: user.id, shop_id: shop_id)
  end
  
end
