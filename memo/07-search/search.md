# 検索フォームの実装

## 条件
- 全投稿を対象
- 検索条件: bodyに検索ワードが含まれている投稿
- ActiveModelを使い実装
- 検索パス/posts/search

## 順序
01. [ActiveModelによりSearchクラスを作成](#ActiveModelによりSearchクラスを作成)
02. [検索用のcontrollerを記述](#検索用のcontrollerを記述)
03. [Viewの作成](#Viewの作成)
04. [ルーティング設定](#ルーティング設定)

## ActiveModelによりSearchクラスを作成
```ruby
class SearchPostForm
  # モデル名の調査 変換 翻訳 バリデーションの機能を使えるようになる
  # Active Recordのようにハッシュを利用して初期化することができる
  # Action Viewヘルパーメソッド formやrenderなどが使えるようになる
  include ActiveModel::Model
  # attr_accessorと同じように属性を利用できるようになる
  include ActiveModel::Attributes

  # パラメータの属性を指定
  attribute :body, :string

  def search
    # Post.distinct 一意制約付きで.allメソッドを利用するようなもの
    # 個人的には必要ないと思ったため設定しない
    Post.where('body LIKE ?', "%#{body}%" if body.present?
  end
end
```

## 検索用のcontrollerを記述
```ruby
class ApplicationController < ActionController::Base
  before_action :set_search_posts_form

  private
  # ヘッダー部分（=共通部分）に検索フォームを置くのでApplicationControllerに実装する
  def set_search_posts_form
    # ActiveModelにより作成したSearchPostsFormクラスのインスタンスを生成
    @search_form = SearchPostsForm.new(search_post_params)
  end

  def search_post_params
    # 指定したキーがない時にエラーを出さないようにする
    # デフォルトが{}となる
    params.fetch(:q, {}).permit(:body)
  end
end
```
```ruby
class PostsController < ApplicationController
  def search
    @posts = @search_form.search.includes(:user).page(params[:page])
  end
end
```

## Viewの作成
```
# model controllerで作成したインスタンスを指定
# url   searchによりurlの指定
# scope 値を渡す際のハッシュ名を指定
= form_with model: @search_form, url: search_posts_path, scope: :q, class: 'form-inline my-2 my-lg-0 mr-auto', method: :get, local: true do |f|
  = f.search_field :body, class: 'form-control mr-sm-2', placeholder: '本文'
  = f.submit 'Search', class: 'btn btn-outline-success my-2 my-sm-0'
```

## ルーティング設定
```
Rails.application.routes.draw do
  resources :posts, shallow: true do
    get :search, on: :collection  # /posts/search
  end
end
```

## このままだとurlのクエリが汚くなってしまう。
`http://localhost:3000/posts/search?utf8=%E2%9C%93&q%5Bbody%5D=program&commit=Search`
**どうしたら綺麗になる?**
こう書き換えたい
`http://localhost:3000/posts/search?body=program`
1. postメソッドにより取得し、redirectによりgetメソッドで表示する
2. link_toのパラメータに含め、値を取得する
3. jsによりパラメータを無理やり書き換える

1,3は実現性がある？2は実現性がない？
1,2ではreloadして同じurlに送る方法が考えられない
3ではreloadしても大丈夫な気がする
どうしたものか、、、
APIとかじゃないから気にしなくていいのかな？

## 参考
[ActiveModel::Attributesを使う](https://qiita.com/kazutosato/items/91c5c989f98981d06cd4)
[RailsのStrong Parametersを調べる](https://qiita.com/mochio/items/45b9172a50a6ebb0bee0)