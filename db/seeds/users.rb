puts 'Start inserting seed "users" ...'

10.times do |i|
    User.create!(
        username: Faker::Name.name,
        email: "example#{i}@example.com",
        password: "hogehoge",
        password_confirmation: "hogehoge"
    )
end