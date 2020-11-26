class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      # ポリモーフィック関連により複数のモデルに関連した通知を作成する
      # subject_type: Model 関連モデルを示す
      # subject_id: Model.id モデルのデータを示す
      t.references :subject, polymorphic: true
      # 誰への通知かを示す
      t.references :user, foreign_key: true
      # 列挙定数によりどこからの通知なのか判断するのに用いる
      t.integer :action_type, null: false
      # 既読を判定する
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
