# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_filter :set_creds, only: :navigator
  before_filter :authenticate, only: :navigator

  def index
    @title = 'Lateral Navigator'
    @meta = 'Generate a visual interface to interact with the data stored in your Lateral API key'
    render :index
  end

  def navigator
    @title = "Lateral Navigator - #{@creds.name}"
    @meta = "#{@creds.name} navigator for Lateral API results"
    render :index
  end

  private

  def set_creds
    @creds = Credentials.find_by! url_hash: params[:hash], slug: params[:slug]
  end

  def authenticate
    return unless @creds.password_protected?
    authenticate_or_request_with_http_basic('Protected navigator') do |username, password|
      username == @creds.username && password == @creds.password
    end
  end
end
