# フォロー機能作成まとめ

## フロー
1. relationshipモデル作成
2. migrationファイル編集
3. アソシエーション記述
4. メソッド作成
5. コントローラー作成
6. view作成
7. ルーティング設定

## 1. relationshipモデル作成
```
$ rails g model Relationship
```

## 2. migrationファイル編集
```
class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      # follower フォロワー
      # followed フォローしたユーザ
      # 存在しないテーブルのためinteger型を設定
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false

      t.timestamps
    end
    # インデックスを設定
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # 一意制約を設定
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
```

## 3. アソシエーション記述
```
class Relationship < ApplicationRecord
  # class_name: 'User' 参照先をUserクラスであると明示する
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # 一意制約を設定
  validates :follower_id, uniqueness: { scope: :followed_id }
end
```
```
class User < ApplicationRecord
  # :active_relationships followingの中間テーブルに用いる架空テーブル
  # class_name: 'Relationship'  参照先をrelationshipクラスであることを明示する
  # foreign_key: 'follower_id'  relationshipsテーブルにアクセスするときの入り口をfollower_idとする
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  # :passive_relationships followersの中間テーブルに用いる架空テーブル
  # class_name: 'Relationship'  参照先をrelationshipクラスであることを明示する
  # foreign_key: 'followed_id'  relationshipsテーブルにアクセスするときの入り口をfollowed_id'とする
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  # :following フォローしているユーザーを参照する架空テーブル
  # through: :active_relationships 中間テーブルを設定する
  # source: :followed 出口をfollowed_idとする
  has_many :following, through: :active_relationships, source: :followed
  # :followers フォロワーを参照する架空テーブル
  # through: :passive_relationships 中間テーブルを設定する
  # source: :follower 出口をfollower_idとする
  has_many :followers, through: :passive_relationships, source: :follower
end
```

## 4. メソッド作成
```
class User < ApplicationRecord
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # scope 可読性を高めるためにメソッドをまとめるために用いる
  # 登録日を新しい順に並べ変え引数の数だけ取り出すメソッド
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

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
end
```

## 5. コントローラー作成
```
class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  def destroy
    # Relationshipモデルよりidにより関係を取り出しfollowed_idに対応するユーザを取得する
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
```

## 6. view作成
```
# フォローリンク
= link_to relationships_path(followed_id: user.id), class: 'btn btn-raised btn-outline-warning', method: :post, remote: true do
  | フォロー
```
```
# アンフォローリンク
= link_to relationship_path(current_user.active_relationships.find_by(followed_id: user.id)), class: 'btn btn-warning btn-raised', method: :delete, remote: true do
  | アンフォロー
```

## 7. ルーティング設定
```
Rails.application.routes.draw do
  resources :relationships, only: %i[create destroy]
end
```