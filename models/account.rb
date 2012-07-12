class Account
  include MongoMapper::Document
  attr_accessor :password, :password_confirmation

  # Keys
  key :name,             String
  key :surname,          String
  key :email,            String
  key :crypted_password, String
  key :role,             String
  key :plivo_uid,        String
  key :plivo_auth_id,    String
  key :plivo_auth_token, String
  key :sip_secret,       String
  key :nickname,         String

  # Validations
  validates_presence_of     :email, :role, :nickname
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/

  # Callbacks
  before_save :encrypt_password, :if => :password_required
  before_save :get_plivo_authid, :if => :plivo_authid_required
  
  ##associations 
  many :authentications
  many :phones
  many :llamadas
  many :plivoapps
  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(:email => email) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  ##
  ##
  #this method returns a array all of the active phone for current user
  def active_phones
    phones = []
    self.phones.each do |phone|
      if phone.active
        #if active add to phone array
        phones << phone
      end 
    end
    if phones.size > 1
      #if more then one add < for plivo   
      p = phones.join("<")
    else 
      p = phones
    end 
    #returns the p object
    p 
  end
  

  private
  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password)
  end

  def password_required
    crypted_password.blank? || password.present?
  end
  
  ## check if plivoauth id required returns true 
  def plivo_authid_required
    plivo_authid.blank?
  end

  ##
  # this retrieves the account authid from plivo
  def get_plivo_authid
    
    #generates a random 15 character name for plivo
    random_name = ('a'..'z').to_a.shuffle[0,15].join

    info = {
      "name" => self.nickname,
      "enabled" => true
    }
    client = Plivo::RestAPI.new(AUTH_ID, AUTH_TOKEN)
    response = client.create_subaccount(info)
    logger.info "THIS IS RESPONSE #{response.inspect}"
    ### returns true of false if valid code
    if response[0] == 201
      self.plivo_uid = nickname
      self.plivo_authid = find_plivo_authid(plivo_uid)
      logger.info "THIS IS RANDOM NAME = #{self.plivo_uid}"
      logger.info "this is plivo auth id = #{self.plivo_authid}"
    end 
    build_new_plivo_app()
    create_sip_endpoint()
  end
   
   def build_new_plivo_app()
      #creates a new pliveo app object
      logger.info "building new app"
      p_app = Plivoapp.new()
      p_app.account_id = self.id
      p_app.auth_id = self.plivo_authid
      p_app.save
     
   end


  def find_plivo_authid(uid)
    auth = ""
    client = Plivo::RestAPI.new(AUTH_ID, AUTH_TOKEN)
    response = client.get_subaccounts()
    logger.info "THIS IS RESPONSE FOR GET SUBACCOUNTS = #{response}"
     if response[0] = 200
      response[1]["objects"].each do |a|
        logger.info "IS UID #{uid} == #{a["name"]}"
        if uid == a["name"]
          logger.info "boom"
          auth = a["auth_id"]
        end
      end 
       
    end
    auth 
  end
  

  def create_sip_endpoint
    logger.info "CREATING ENDPOINT"
    self.sip_secret = ('a'..'z').to_a.shuffle[0,9].join
    info = {
      "username" => self.nickname,
      "password" => self.sip_secret,
      "alias" => self.id

    }
    client = Plivo::RestAPI.new(AUTH_ID, AUTH_TOKEN)
    response = client.create_endpoint(info)
    logger.info "THIS IS CREATE ENDPOINT RESPONSE #{response.inspect}"
    if response[0] = 201
      logger.info "ENDOPOINT CREATED"
    end
  end 


end
