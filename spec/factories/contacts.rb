# frozen_string_literal:true

FactoryBot.define do
	factory :contact do
		name { Faker::Name.name }
		dob { Faker::Date.birthday(min_age: 18, max_age: 65) }
		phone { Faker::PhoneNumber.phone_number }
		address { Faker::Address.full_address }
		cc_number { Faker::Finance.credit_card }
		cc_network { Faker::Business.credit_card_type }
		email { Faker::Internet.email }
		user_id { FactoryBot.create(:user).id }
	end
end
