class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable,:validatable



  attachment :profile_image, destroy: false
  has_many :books,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  has_many :favorites

  enum  gender: { unknown: 0, male: 1}

  scope :get_by_name, ->(name) {
    where("name like ?", "%#{name}%")
  }
  scope :get_by_gender, ->(gender) {
    where(gender: gender)
  }


#いいね一覧＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
has_many :favorite_books,through: :favorites,source: :book
#================================================================


# userのbookがきえたら、同じく消えるdependentのコード
has_many :entries
has_many :direct_messages
has_many :rooms, through: :entries



# ↓フォロワーした　のつくりかた
# ====================自分がフォローしているユーザーとの関連 ===================================
  #フォローする側のUserから見て、フォローされる側のUserを(中間テーブルを介して)集める。なので親はfollowing_id(フォローする側)
  has_many :relationships, foreign_key: 'user_id'
  # 中間テーブルを介して「follower」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :relationships, source: :follow
 # フォロー上relationships
 # ========================================================================================


# ====================自分がフォローされるユーザーとの関連 ===================================
  #フォローされる側のUserから見て、フォローしてくる側のUserを(中間テーブルを介して)集める。なので親はfollower_id(フォローされる側)
 # フォロワーされてる下reverse_of_relationships
 has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
   # 中間テーブルを介して「following」モデルのUser(フォローする側)を集めることを「followers」と定義
   has_many :followers, through: :reverse_of_relationships, source: :user
# =========================\==============================================================


# フォローする
def follow(other_user)
  unless self == other_user
    self.relationships.find_or_create_by(follow_id: other_user.id)
  end
end
# フォロー外す
def unfollow(other_user)
  relationship = self.relationships.find_by(follow_id: other_user.id)
  relationship.destroy if relationship
end
# フォロー確認# 現在のユーザーがフォローしてたらtrueを返す
def following?(other_user)
  self.followings.include?(other_user)
end
# ↑ここまでフォロー機能


  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, presence:true, length: {maximum: 20, minimum: 2}
  validates :introduction,length:{maximum:50}

  def self.search(search)
    if search
      User.where(['name LIKE ?', "%#{search}%"])

    else
      User.all
    end
  end



  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

end
