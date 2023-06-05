# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'validates fatory works' do
    context 'with valid attributes' do
      it 'is valid' do
        expect(build(:contact)).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'requires a name' do
        contact = build(:contact, name: nil)
        expect(contact).to_not be_valid
        expect(contact.errors[:name]).to include("can't be blank")
      end

      it 'requires a dob' do
        contact = build(:contact, dob: nil)
        expect(contact).to_not be_valid
        expect(contact.errors[:dob]).to include("can't be blank")
      end

      it 'requires a address' do
        contact = build(:contact, address: nil)
        expect(contact).to_not be_valid
        expect(contact.errors[:address]).to include("can't be blank")
      end

      it 'requires a phone' do
        contact = build(:contact, phone: nil)
        expect(contact).to_not be_valid
        expect(contact.errors[:phone]).to include("can't be blank")
      end

      it 'requires a email' do
        contact = build(:contact, email: nil)
        expect(contact).to_not be_valid
        expect(contact.errors[:email]).to include("can't be blank")
      end
    end
  end
end
