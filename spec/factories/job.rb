require 'faker'

FactoryGirl.define do
  factory :job do
    title Faker::Lorem.sentence  
    category
  end
end