class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      # follower フォロワー）
      # followed フォローしたユーザ
      # follower(誰) から followed(誰) にフォローする
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