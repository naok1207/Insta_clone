puts 'Start inserting seed "posts" ...'

User.limit(10).each do |user|
    post = user.posts.create!(
        body: Faker::Hacker.say_something_smart,
        remote_images_urls: %w[https://picsum.photos/400/400 https://picsum.photos/400/400]
    )
    puts "post#{post.id} created"
end