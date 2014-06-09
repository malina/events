namespace :populate do
  desc "Populate DB with data"

  task users: :environment do
    count = 1000

    while count>0 do
      user = User.create(name: Faker::Name.first_name, email: Faker::Internet.email, password: "qwerty", password_confirmation: "qwerty", gender: [0,1].sample(1)[0], age: rand(99))
      count-=1
    end 
  end

  task meetings: :environment do
    count = 300
    now = Time.zone.now
    puts "populate meetings #{now} #{count}"
    while count>0 do
      m = Meeting.create(name: Faker::Company.catch_phrase,  started_at: now+60*60*(Faker::Number.number(2).to_i - 300))
      m.save

      User.limit(Faker::Number.number(3).to_i).order("RANDOM()").each do |u|
        m.add_user! u, [0,1].sample(1)[0]
      end

      puts "--#{count}"

      count-=1
    end 
  end

end
