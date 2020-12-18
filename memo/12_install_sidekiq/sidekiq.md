# sidekiqとは
Sidekiqは非同期処理を行いたい際に利用するgem。複数のジョブを同時に実行することにより、メモリを節約することが可能

## 導入

```ruby
# Gemfile

gem 'sidekiq'
gem 'sinatra', require: false
```
追記

```ruby
# config/application.rb

config.active_job.queue_adapter = :sidekiq
```
追記

```ruby
# config/initializers/sidekiq.rb

Sidekiq.configure_server do |config|
  config.redis = {
      url: 'redis://localhost:6379'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
      url: 'redis://localhost:6379'
  }
end
```
作成

```
# config/sidekiq.yml

:concurrency: 25
:queues:
  - default
  - mailers

```
作成

```
bundle exec sidekiq -C config/sidekiq.yml

```
設定を反映して起動
バックグラウンドで起動する場合`-d`オプションをつける

```
# config/routes.rb

require 'sidekiq/web'
mount Sidekiq::Web, at: "/sidekiq"
```
追記