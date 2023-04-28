require 'rails_helper'

RSpec.describe ImportDataJob, type: :worker do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:filename) { './Koombea Contacts File - Hoja 1.csv' }
    let(:request_params) do
      {
        name: 'name',
        dob: 'dob',
        phone: 'phone',
        address: 'address',
        cc_number: 'cc_number',
        email: 'email',
        file: filename
      }.transform_keys(&:to_s)
    end
    it 'loads file correctly: finished' do
      job_id = SecureRandom.hex(10)
      allow_any_instance_of(ImportDataJob).to receive(:require).with(request_params).and_return(true)

      # perform the worker
      expect{
        ImportDataJob.new.perform(user.id, request_params, job_id)
      }.to change(Contact, :count).by(10)

      # Log Created Succesfully
      expect(ImportDataLog.count).to eq(1)

      # Message Errors Added Succesfully
      expect(ImportDataLog.last.message_errors.count).to eq(3)

      # Status updated
      expect(ImportDataLog.last.status).to eq('finished')
    end

    it 'loads file correctly: failed' do
      # Running the same process twice makes the second fail
      # Since all records added on the first run are repeated on the second run
      # and therefore fail on repeteaded email

      allow_any_instance_of(ImportDataJob).to receive(:require).with(request_params).and_return(true)

      # FIRST RUN
      job_id = SecureRandom.hex(10)
      ImportDataJob.new.perform(user.id, request_params, job_id)

      # SECOND RUN
      job_id = SecureRandom.hex(10)
      expect{
        ImportDataJob.new.perform(user.id, request_params, job_id)
      }.to_not change(Contact, :count)

      # Log Created Succesfully
      expect(ImportDataLog.count).to eq(2)

      # Message Errors Added Succesfully
      expect(ImportDataLog.last.message_errors.count).to eq(13)

      # Status updated to failed since no record was added
      expect(ImportDataLog.last.status).to eq('failed')
    end
  end
end
