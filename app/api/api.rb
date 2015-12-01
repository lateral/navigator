# Mount various API functionality
class API < Grape::API
  format :json

  # error formatting
  rescue_from :all
  error_formatter :json, lambda { |message, backtrace, _options, _env|
    if Rails.env.production?
      { message: message }.to_json
    else
      { message: message, backtrace: backtrace }.to_json
    end
  }
  rescue_from Grape::Exceptions::ValidationErrors do |e|
    rack_response({ message: e.message }.to_json, 400)
  end
  rescue_from ActiveRecord::RecordInvalid do |error|
    message = error.record.errors.messages.map { |_, msg| msg.first }
    error!(message.join(', '), 400)
  end
  rescue_from ActiveRecord::RecordNotFound do |e|
    rack_response({ message: e.message }.to_json, 404)
  end

  helpers RequestHelpers

  # Use keyword search to query documents
  params do
    requires :key, type: String, allow_blank: false
    requires :name, type: String, allow_blank: false
    requires :password_protected, type: Boolean, allow_blank: false
    optional :username, type: String
  end
  post '/navigators' do
    error! 'username is missing', 400 if params[:username].blank? && params[:password_protected] == true
    Credentials.create!(declared(params))
  end

  # Use keyword search to query documents
  params do
    requires :hash, type: String, allow_blank: false
    requires :slug, type: String, allow_blank: false
    requires :keywords, type: String, allow_blank: false
  end
  get '/:hash/:slug/documents' do
    authorise!

    get_json "/documents?keywords=#{params[:keywords]}"
  end

  # Get a document
  params do
    requires :hash, type: String, allow_blank: false
    requires :slug, type: String, allow_blank: false
    requires :id, type: Integer, allow_blank: false
  end
  get '/:hash/:slug/documents/:id' do
    authorise!
    get_json "/documents/#{params[:id]}/"
  end

  # Get recommendations and return all the document objects that were recommended
  params do
    requires :hash, type: String, allow_blank: false
    requires :slug, type: String, allow_blank: false
    requires :id, type: Integer, allow_blank: false
  end
  get '/:hash/:slug/documents/:id/similar' do
    authorise!

    # Get the recommendations
    recommendations = get_json "/documents/#{params[:id]}/similar"

    recommendations.shift if recommendations.first['id'] == params[:id]

    # Create object for /batch endpoint
    common = { method: 'get', headers: { 'Subscription-Key': @subscription_key } }
    ops = recommendations.map { |doc| { url: "/documents/#{doc['id']}" }.merge(common) }

    # Post requests to /batch
    batch_results = post_json '/batch', ops: ops, sequential: true

    # Map results to merge the /batch response body with the recommendation
    batch_results['results'].map do |result|
      recommendations.find { |rec| rec['id'] == result['body']['id'] }.merge(result['body'])
    end
  end

  # Return 25 documents from a random page of /documents
  params do
    requires :hash, type: String, allow_blank: false
    requires :slug, type: String, allow_blank: false
  end
  get '/:hash/:slug/random-documents' do
    authorise!

    # Get one document to access the `total` header and calculate the number of pages with it
    request = get '/documents', per_page: 1
    pages = request.headers[:total].to_i / 25

    # Request and return a random page
    get_json "/documents?page=#{rand(1..pages)}"
  end

  # Catch 404 errors
  resource do
    get { error! 'API path not found', 404 }
  end

  route :any, '*path' do
    error! 'API path not found', 404
  end
end
