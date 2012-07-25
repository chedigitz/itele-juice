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
    
    # get all applications
    p_apps.each do |a|
    	# for each app request application details 
       app_info = a.update_resource_hash(url) 
      logger.info "app info hash = #{app_info.inspect}" 
    end
    
   end
  


end
