# 編集時の画像のプレビュー

編集時の画像ファイルを選択した際にプレビューを更新

## view
.html.slim
```ruby
 = image_tag @user.avatar.url, size: '100x100', class: 'rounded-circle', id: 'preview'
.form-group
  = f.label :avatar
  = f.file_field :avatar, class: 'form-control', id: 'edit_image', accept: 'image/*'
```
.scss
```scss
#preview {
    width: 100px;
    height: 100px;
    object-fit: cover;
}
```

## js
.js
```js
$(function() {
  var image = $('#edit_image');
  # ファイルが変更された時に発火
  image.on('change', function() {
    var image_ = image.prop('files')[0];
    # FileReader 画像を読み込み
    var reader_ = new FileReader();
    # 読み込み完了時に発火
    reader_.onload = function() {
      # imageのsrcを書き換え
      $('#preview').attr('src', reader_.result);
    }
    # 読み込みを実行 ここでonloadが発火する
    reader_.readAsDataURL(image_);
  })
})
```
