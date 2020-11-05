# パーシャルの勘違いについて

今までは`render partial: 'posts/post', collection: @posts`のように利用していたため
@postsの要素それぞれを単数系にしたもの(post)がpartialの中身に渡されると思っていた

しかし、`render partial: 'posts/thumbnail_post', collection: @posts`の利用により
渡されるのは@postsの要素をthumbnail_postに格納する
