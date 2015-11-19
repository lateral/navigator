require 'rails_helper'

RSpec.describe API do
  describe 'GET /api' do
    it 'returns a 404' do
      get '/api'
      expect(response).to be_missing
      expect(json_response['message']).to eq('API path not found')
    end
  end
end
