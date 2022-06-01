class Favorite < ApplicationRecord
  belongs_to :user

  #
  #def favorited_by?(user, shop_id)
  #  self.exists?(user_id: user.id, shop_id: shop_id)
  #end

end
