require 'rails_helper'

RSpec.describe Credentials, type: :model do
  before(:each) do
    stub_request(:any, %r{#{API_URL}/ping}).to_rack(FakeLateral.new(key: 'test'))
  end

  describe '#to_json' do
    HIDDEN_FIELDS = [:created_at, :updated_at, :id, :key, :updated_at]

    HIDDEN_FIELDS.each do |field|
      it "doesn't display the #{field} field" do
        creds = FactoryGirl.create(:credentials, key: 'test', name: Faker::Name.name).to_json
        parsed = JSON.parse creds
        expect(parsed).to_not have_key(field.to_s)
        expect(creds).to_not include("\"#{field}\":")
      end
    end
  end

  describe 'validation' do
    it "doesn't allow an invalid key" do
      creds = FactoryGirl.build(:credentials, key: 'invalid', name: 'test')
      expect(creds).to be_invalid
    end

    it "doesn't allow a missing key" do
      creds = FactoryGirl.build(:credentials, name: 'test')
      expect(creds).to be_invalid
    end

    it "doesn't allow a missing name" do
      creds = FactoryGirl.build(:credentials, key: 'test')
      expect(creds).to be_invalid
    end

    it 'validates username and password if password_protected is true' do
      creds = FactoryGirl.build(:credentials, key: 'test', name: 'test', password_protected: true)
      expect(creds).to be_invalid
      expect(creds.errors[:username]).to eq(["can't be blank"])
    end

    it 'allows valid params' do
      creds = FactoryGirl.build(:credentials, key: 'test', name: 'test')
      expect(creds).to be_valid
    end
  end

  describe 'hooks' do
    it 'sets the url_hash' do
      creds = FactoryGirl.create(:credentials, key: 'test', name: 'test')
      expect(creds).to be_valid
      expect(creds.url_hash).to_not eq(nil)
    end

    it 'sets the slug' do
      creds = FactoryGirl.create(:credentials, key: 'test', name: 'This is a TEST!!!')
      expect(creds).to be_valid
      expect(creds.slug).to eq('this-is-a-test')
    end

    it 'sets the password' do
      creds = FactoryGirl.create(:credentials, key: 'test', name: 'This is a TEST!!!',
                                               password_protected: true, username: 'max')
      expect(creds).to be_valid
      expect(creds.url_hash).to_not eq(nil)
    end
  end
end
