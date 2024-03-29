FactoryBot.define do
  factory :cosmonaut do
    sequence(:first_name) do |n|
      Faker::Config.random = Random.new(n)
      Faker::Name.first_name
    end
    sequence(:last_name) do |n|
      Faker::Config.random = Random.new(n)
      Faker::Name.last_name
    end
    sequence(:physical_condition) do |n|
      Cosmonaut::LEVELS.sample random: Random.new(n)
    end
    sequence(:mental_endurance) do |n|
      Cosmonaut::LEVELS.sample random: Random.new(n)
    end
  end
end
