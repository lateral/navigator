class KeyValidator < ActiveModel::Validator
  def validate(record)
    RestClient.get "#{API_URL}/ping", 'Subscription-Key' => record.key
  rescue RestClient::Forbidden
    record.errors[:key] << 'key is not valid'
  end
end

class Credentials < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with KeyValidator

  validates :key, presence: true
  validates :name, presence: true
  validates :username, presence: true, if: :password_protected?
  before_save :set_url_hash
  before_save :set_slug
  before_save :set_password

  def as_json(options = {})
    super({ except: [:created_at, :updated_at, :id, :key, :updated_at] }.merge(options))
  end

  def basic_auth
    ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end

  private

  def set_url_hash
    self.url_hash = SecureRandom.hex[0..7]
  end

  def set_password
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    self.password = (0...12).map { o[rand(o.length)] }.join
  end

  def set_slug
    self.slug = name.parameterize
  end
end
