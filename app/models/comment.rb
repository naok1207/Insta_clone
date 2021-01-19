# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # Activityモデルと関連を定義
  has_one :activity, as: :subject, dependent: :destroy

  validates :body, presence: true, length: { maximum: 100 }

  # トランザクション処理によりモデルが作成された場合のみコールバックを行う
  after_create_commit :create_activities

  private

  # コールバック用メソッド
  # 通知を作成する
  def create_activities
    if post.user.notification_on_comment? && post.user != current_user
      Activity.create(subject: self, user: post.user, action_type: :commented_to_own_post)
      UserMailer.commented_to_own_post(post.user, user, self).deliver_now
    end
  end
end
