# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  avatar           :string(255)
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  mount_uploader :avatar, AvatarUploader

  validates :username, presence: true, length: { minimum: 4, maximum: 20 }
  validates :email, uniqueness: true

  # if: -> { new_record? || changes[:crypted_password] }
  # ユーザーがパスワード以外のプロフィール項目を更新したい場合に、パスワードの入力を省略できるようになる。
  validates :password, presence: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  # :active_relationships followingの中間テーブルに用いる架空テーブル
  # class_name: 'Relationship'  参照先をrelationshipクラスであることを明示する
  # foreign_key: 'follower_id'  relationshipsテーブルにアクセスするときの入り口をfollower_idとする
  has_many :active_relationships,   class_name: 'Relationship',
                                    foreign_key: 'follower_id',
                                    dependent: :destroy
  # :passive_relationships followersの中間テーブルに用いる架空テーブル
  # class_name: 'Relationship'  参照先をrelationshipクラスであることを明示する
  # foreign_key: 'followed_id'  relationshipsテーブルにアクセスするときの入り口をfollowed_id'とする
  has_many :passive_relationships,  class_name: 'Relationship',
                                    foreign_key: 'followed_id',
                                    dependent: :destroy
  # :following フォローしているユーザーを参照する架空テーブル
  # through: :active_relationships 中間テーブルを設定する
  # source: :followed 出口をfollowed_idとする
  has_many :following, through: :active_relationships,  source: :followed
  # :followers フォロワーを参照する架空テーブル
  # through: :passive_relationships 中間テーブルを設定する
  # source: :follower 出口をfollower_idとする
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :activities, dependent: :destroy

  # scope 可読性を高めるためにメソッドをまとめるために用いる
  # 登録日を新しい順に並べ変え引数の数だけ取り出すメソッド
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
  

  def like(post)
    likes.create(post_id: post.id)
  end

  def unlike(post)
    likes.find_by(post_id: post.id).destroy
  end

  def like?(post)
    like_posts.include?(post)
  end

  # フォローをするメソッド
  def follow(other_user)
    # following にユーザを格納することでcreateと同様の処理を実現している
    following << other_user
  end

  # フォローを外すメソッド
  def unfollow(other_user)
    # following から特定のユーザを削除する
    following.destroy(other_user)
  end

  # フォローを判定するメソッド
  def following?(other_user)
    # following に特定のユーザが含まれているか判定する
    following.include?(other_user)
  end

  # フォローしているユーザーと自身の投稿だけを取得する
  # self.followings_ids 自身がフォローしているユーザのid一覧
  # id一覧の中に自身のidを追加することで自身の投稿を取得
  def feed
    Post.where(user_id: following_ids << id)
  end
end
