# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
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

  validates :username, presence: true, length: { minimum: 4, maximum: 20 }
  validates :email, uniqueness: true

  validates :password, presence: true, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
