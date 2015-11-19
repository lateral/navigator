require 'sinatra/base'

module FakeLateralHelper
  def init_fake_lateral!
    fake_lateral = FakeLateral.new(key: 'test')
    @results = fake_lateral.instance_variable_get(:@instance).instance_variable_get(:@results)
    @documents = fake_lateral.instance_variable_get(:@instance).instance_variable_get(:@documents)
    stub_request(:any, /#{API_URL}/).to_rack(fake_lateral)
  end
end

RSpec.configure do |config|
  config.include FakeLateralHelper
end

class FakeLateral < Sinatra::Base
  def initialize(hash = {})
    @key = hash[:key]
    @documents = hash[:documents] || 5.times.map { lateral_document }
    @results = hash[:results] || 5.times.map { lateral_document }
  end

  get '/ping/?' do
    content_type :json
    return status 403 if env['HTTP_SUBSCRIPTION_KEY'] != @key
    status 200
    { count: 200 }.to_json
  end

  get '/documents/?' do
    content_type :json
    status 200
    response.headers['total'] = 200
    @documents.to_json
  end

  get '/documents/:id/?' do
    content_type :json
    status 200
    @documents.find { |doc| doc[:id] == params['id'].to_i }.to_json
  end

  get '/documents/:id/similar/?' do
    content_type :json
    status 200
    @results.map do |doc|
      { id: doc[:id], similarity: 0.001 }
    end.to_json
  end

  post '/batch/?' do
    content_type :json
    status 200
    payload = JSON.parse request.body.read
    results = payload['ops'].map do |op|
      id = op['url'].gsub('/documents/', '').to_i
      { body: @results.find { |doc| doc[:id] == id } }
    end
    { results: results }.to_json
  end

  private

  def lateral_document
    {
      id: rand(0...100_000_000_000),
      text: IO.read(Rails.root.join('spec/fixtures/texts', "#{TEXTS.sample}.txt")),
      meta: {
        title: Faker::Lorem.sentence(3),
        date: Faker::Time.backward(14).to_s,
        author: Faker::Name.name,
        url: Faker::Internet.url
      },
      created_at: Faker::Time.backward(14).to_s,
      updated_at: Faker::Time.backward(14).to_s,
      document_cluster_assignments: []
    }
  end
end
