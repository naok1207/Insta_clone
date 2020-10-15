puts 'Start inserting seed "comments" ...'

User.limit(10).each do |user|
    10.times do
        begin
            comment = user.comments.create!(
                body: Faker::Hacker.say_something_smart,
                post_id: Post.all.sample.id
            )
            puts "comment#{comment.id} created"
        rescue
            redo
        end
    end
end