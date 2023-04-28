# frozen_string_literal:true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation factory bot' do
    context 'with valid attributes' do
      it 'is valid' do
        expect(build(:user)).to be_valid
      end
    end
  end

  describe 'creation' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect { create(:user) }.to change(User, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'raises a validation error' do
        expect {
          create(:user, email: nil)
        }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email can't be blank")
      end
    end
  end
end
