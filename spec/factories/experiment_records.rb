FactoryBot.define do
  factory :experiment_record do
    experimented_on { "MyString" }
    name { "MyString" }
    start_at { "MyString" }
    end_at { "MyString" }
    description { "MyText" }
    required_time { "MyString" }
  end
end
