require 'rails_helper'

RSpec.describe API do
  describe 'GET /api' do
    it 'returns a 404' do
      get '/api'
      expect(response).to be_missing
      expect(json_response['message']).to eq('API path not found')
    end
  end

  describe '/:hash/:slug/random-documents' do
    before(:each) do
      # Mock the Lateral API with valid key of 'test'
      # Sets @results and @documents instance variables
      init_fake_lateral!
      @creds = FactoryGirl.create(:credentials, key: 'test', name: 'Max')
    end

    it 'errors if auth incorrect' do
      creds = FactoryGirl.create(:credentials, key: 'test', name: 'Max', password_protected: true,
                                               username: 'max', password: 'password')
      get "/api/#{creds.url_hash}/#{creds.slug}/random-documents"
      expect(response).to have_http_status(403)
    end

    it 'works if auth correct' do
      creds = FactoryGirl.create(:credentials, key: 'test', name: 'Max', password_protected: true,
                                               username: 'max', password: 'password')
      get "/api/#{creds.url_hash}/#{creds.slug}/random-documents", nil, 'Authorization' => creds.basic_auth
      expect(response).to be_success
    end

    it 'returns a list of documents' do
      get "/api/#{@creds.url_hash}/#{@creds.slug}/random-documents"
      expect(response).to be_success
      expect(json_response.length).to eq(5)
      expect(json_response.first['id']).to eq(@documents.first[:id])
    end
  end
end
