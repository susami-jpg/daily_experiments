FactoryBot.define do
  factory :experiment_record do
    experimented_on { "2021/09/06" }
    name { "Cut&TAG" }
    start_at { "8:00" }
    end_at { "12:00" }
    description { "工程Gまで行った。" }
    user
  end
end
