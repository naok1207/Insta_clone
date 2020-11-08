# 画像リサイズ

縦横それぞれ400pxの指定があったためリサイズを作成

## Uploader作成
```
$ rails g uploader Avatar
```
AvatarUploaderが作成される

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  # RMagickを読み込む
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # resize_to_fill 縦横比を変更せずリサイズ
  process resize_to_fill: [400, 400]

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
```

## 参考
[CarrierWave+MiniMagickで使う、画像リサイズのメソッド](https://qiita.com/wann/items/c6d4c3f17b97bb33936f)
[CarrierWave + RMagick 画像のリサイズをまとめてみました](http://noodles-mtb.hatenablog.com/entry/2013/07/08/151316)