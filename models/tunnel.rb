class Tunnel
  include MongoMapper::Document

  # key <name>, <type>
  key :url, String
  key :active, Boolean
  timestamps!
 
  before_save :update_plivo_applications, :if => :update_required
  
  private
  
  def update_required
  	self.changed?  	
  end

  def update_plivo_applications
    logger.info "UPDATING APPS START"
    p_apps = Plivoapp.all
    c = Plivo::RestAPI.new(AUTH_ID, AUTH_TOKEN)
    p_apps.each do |a|
    	urls = a.all_urls
    	logger.info "UPDATING ALL THE URLS IN #{url.inspect}"
    	r= c.modify_application(urls)
    	if r[0] = 201
    		a.update_all_urls(url)
    	end
    end
    
    end
  


end
