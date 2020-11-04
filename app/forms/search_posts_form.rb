class SearchPostsForm
  # モデル名の調査 変換 翻訳 バリデーションの機能を使えるようになる
  # Active Recordのようにハッシュを利用して初期化することができる
  # Action Viewヘルパーメソッド formやrenderなどが使えるようになる
  include ActiveModel::Model
  # attr_accessorと同じように属性を利用できるようになる
  include ActiveModel::Attributes

  # パラメータの属性を指定
  attribute :body, :string

  def search(body)
    # Post.distinct 一意制約付きで.allメソッドを利用するようなもの
    # 個人的には必要ないと思ったため設定しない
    Post.where('body LIKE ?', "%#{body}%") if body.present?
  end
end