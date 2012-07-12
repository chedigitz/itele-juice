class Plivoapp
  include MongoMapper::Document

  # key <name>, <type>
  key :answer_url, String
  key :hangup_url, String
  key :app_name, String
  key :answer_method, String
  key :hangup_url, String
  key :fallback_url, String
  key :fallback_method, String
  key :message_url, String
  key :message_method, String
  key :account_id, ObjectId
  key :number_ids, Array, :typecast => "ObjectId"
  key :auth_id, String
  timestamps!

  belongs_to :account
  many :numbers, :in => :number_ids

  before_save :update_pliveo_app, :if => :update_required

  
  
  def all_urls(tunnel)
    # accepts a tunnel an returns all app urls
    urls = {
      "answer_url" => "#{tunnel}/calls/#{account_id}/new",
      "hangup" => "#{tunnel}/calls/#{account_id}/hangup",
      "fallback" => "#{tunnel}/calls/#{account_id}/fallback",
      "message" => "#{tunnel}/calls/#{account_id}/message"
    }
    urls    
  end

  def update_all_urls(tun_url)
    # accepts tunnel url and updates all the attributes after creating url hash
    urls = all_urls(tun_url)
    self.update_attributes(urls)    
  end

  private
  def update_pliveo_app()
    info = {
      "answer_url" => build_url(account_id,"answer"),
      "app_name" => account_id,
      "hangup_url" => build_url(account_id,"hangup"),
      "fallback_url" => build_url(account_id,"fallback"),
      "message_url" => build_url(account_id,"message")
    }   
    # plivo call 
    c = Plivo::RestAPI.new(AUTH_ID, AUTH_TOKEN)
    r = c.create_application(info)
    logger.info "APPLICATION CREATE RESPONSE IS #{r.inspect}"

    if r[0] = 201
    # app is created successfully save to database 
      logger.info "created app!"
       prepare_for_save(info)
    end
  end

  def prepare_for_save(info)
    self.answer_url = info["answer_url"]
    self.app_name = account_id
    self.hangup_url = info["hangup_url"]
    self.fallback_url = info["fallback_url"]
    self.message_url = info["message_url"]
    self.account_id = account_id
  end

  def update_required
    app_name.blank?    
  end

  def build_url(account_id, action)
    # accepts account object
    # action hangup, fallback, message, answer
    tun = Tunnel.find_by_active(true)
    url_p = tun.url
    case action
    when "answer"
      url = "#{url_p}/calls/#{account_id}/new"
    when "hangup"
      url = "#{url_p}/calls/#{account_id}/hangup"
    when "fallback"
      url = "#{url_p}/calls/#{account_id}/fallback"
    when "message"
      url = "#{url_p}/call/#{account_id}/message"
    url 
    
    end

    
  end



end
