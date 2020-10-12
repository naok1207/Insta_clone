puts 'Start inserting seed "comments" ...'

User.limit(10).each do |user|
    10.times do
        begin
            comment = user.comments.create!(
                body: Faker::Hacker.say_something_smart,
                post_id: Post.where( 'id >= ?', rand(Post.first.id..Post.last.id) ).first.id
            )
            puts "comment#{comment.id} created"
        end
    end
end