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
  key :info, Hash
  timestamps!

  belongs_to :account
  many :numbers, :in => :number_ids

  # before_save :create_pliveo_app, :if => :update_required

  
  def initialize()
    create_pliveo_app()
  end


  
  def all_urls(tunnel)
    # accepts a tunnel an returns all app urls
    urls = {
      "answer_url" => "#{tunnel}/account/#{self.account_id}/calls/new",
      "hangup_url" => "#{tunnel}/account/#{self.account_id}/calls/hangup",
      "fallback_url" => "#{tunnel}/account/#{self.account_id}/calls/fallback",
      "message_url" => "#{tunnel}/account/#{self.account_id}/calls/message"
      # "app_name" => self.app_name
    }
    logger.info "this all urls #{urls.inspect}"
    urls    
  end

  def update_all_urls(tun_url)
    # accepts tunnel url and updates all the attributes after creating url hash
    urls = all_urls(tun_url)
    self.update_attributes(urls)    
  end

  def get_resource_hash
    # returns app resource uri
    if info_update_required?
      update_app_info()
    end 
    info
  end 
  def update_resource_hash(tunnel)
    self.update_all_urls(tunnel)
    update_app_info()
    info 
  end


  private
  def update_app_info()
      c = Plivo::RestAPI.new(self.account.plivo_authid, self.account.plivo_auth_token)
      r = c.get_applications()
      logger.info "response from get applications #{r.inspect}"
      # response for all applications for sub account
      if r[0] == 200
        #response is valid
          logger.info "app objects is #{r[1]["objects"].inspect}"
          sub_account_apps = r[1]["objects"]
          sub_account_apps.each do |s_app|
            # parse all apps if more then one          
             if s_app["app_name"] == self.app_name
               self.info = s_app
               self.save
               update_plivo(c)
             end
          end
      end
  end

  def update_plivo(client)
    urls = {
      "answer_url" => self.answer_url,
      "hangup_url" => self.hangup_url,
      "fallback_url" => self.fallback_url,
      "message_url" => self.message_url
    }
    logger.info "UPDATING ALL THE URLS IN #{urls.inspect}"
    app_id = self.info["app_id"]
    path = '/Application/' + app_id + '/'
    logger.info "path to API IS #{path.to_s}"
    r = client.modify_application(urls, path)
    logger.info "response from url update #{r.inspect}"
    # if r[0] == 202
      # self.update_all_urls(url)
    # end
    
  end

  ##creates plivo app usin api
  def create_pliveo_app()
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

  def info_update_required?
    info.blank? || self.changed?
  end


  def build_url(account_id, action)
    # accepts account object
    # action hangup, fallback, message, answer
    tun = Tunnel.find_by_active(true)
    url_p = tun.url
    case action
    when "answer"
      url = "#{url_p}/account/#{self.account_id}/calls/new"
    when "hangup"
      url = "#{url_p}/account/#{self.account_id}/calls/hangup"
    when "fallback"
      url = "#{url_p}/account/#{self.account_id}/calls/fallback"
    when "message"
      url = "#{url_p}/account/#{self.account_id}/calls/message"
    logger.info "THIS IS BUILD URL #{url.inspect}"

    url 
    
    end

    
  end



end
