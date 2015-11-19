require 'rspec/expectations'

# Functions to help test the grape API
module GrapeHelper
  extend RSpec::Matchers::DSL

  def json_response
    JSON.parse(response.body)
  end

  def check_pagination_headers
    expect(response.headers['Total']).to eq(200.to_s)
    expect(response.headers).to have_key('Link')
    expect(response.headers['Per-Page']).to eq(25.to_s)
  end

  matcher :not_find do |model, value|
    match do |actual|
      actual.status == 404
    end
    match do |actual|
      @message = JSON.parse(actual.body)['message']
      if value
        @message == "Couldn't find #{model} with 'id'=#{value}"
      else
        # @message.include?("Couldn't find all #{model}s") ||
        @message.include?("Couldn't find #{model}") || @message.include?("Couldn't find all #{model}s")
      end
    end
    failure_message do |actual|
      message = "Couldn't find #{model}"
      message = "Couldn't find #{model} with 'id'=#{value}" if value
      %(Status:
  expected: 404
       got: #{actual.status}
Message:
  expected: "#{message}"
       got: "#{@message}")
    end
  end

  matcher :return_insufficient_permission do
    match do |actual|
      actual.status == 403
    end
    match do |actual|
      @message = JSON.parse(actual.body)['message']
      @message == 'Insufficient permissions'
    end
    failure_message do |actual|
      %(Status:
  expected: 403
       got: #{actual.status}
Message:
  expected: "Insufficient permissions"
       got: "#{@message}")
    end
  end
end

RSpec.configure do |config|
  config.include GrapeHelper, type: :request
end
