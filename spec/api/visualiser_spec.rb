require 'rails_helper'

RSpec.describe API do
  describe 'POST /navigators' do
    it 'errors if no key sent' do
      post '/api/navigators', name: 'Max', password_protected: false
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('key is missing, key is empty')
    end

    it 'errors if no name sent' do
      post '/api/navigators', key: 'key', password_protected: false
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('name is missing, name is empty')
    end

    it 'errors if no password_protected sent' do
      post '/api/navigators', name: 'Max', key: 'key'
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('password_protected is missing, password_protected is empty')
    end

    it 'errors if empty key' do
      post '/api/navigators', key: '', name: 'Max', password_protected: false
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('key is empty')
    end

    it 'errors if empty name' do
      post '/api/navigators', name: '', key: 'key', password_protected: false
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('name is empty')
    end

    it 'errors if empty password_protected' do
      post '/api/navigators', password_protected: '', name: 'Max', key: 'key'
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('password_protected is empty')
    end

    it 'errors if password_protected is invalid' do
      post '/api/navigators', password_protected: 'invalid', name: 'Max', key: 'key'
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('password_protected is invalid')
    end

    it 'errors if password_protected is true and username empty' do
      post '/api/navigators', password_protected: true, name: 'Max', key: 'key'
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('username is missing')
    end

    it 'errors if the subscription key is invalid' do
      stub_request(:any, %r{#{API_URL}/ping}).to_rack(FakeLateral.new(key: 'nope'))
      post '/api/navigators', password_protected: false, name: 'Max', key: 'mp[e'
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('key is not valid')
    end

    it 'creates if subscription key valid' do
      stub_request(:any, %r{#{API_URL}/ping}).to_rack(FakeLateral.new(key: 'nope'))
      post '/api/navigators', password_protected: false, name: 'Max', key: 'mp[e'
      expect(response).to have_http_status(400)
      expect(json_response['message']).to eq('key is not valid')
    end
  end
end
