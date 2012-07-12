class Authentication
  include MongoMapper::Document

  # key <name>, <type>
  key :provider, String
  key :uid, String
  key :info, Hash
  key :credentials, Hash
  timestamps!

  belongs_to :account 
  key :account_id, ObjectId
  
  timestamps!

  def profile_url
    url = '' 
     if provider == 'twitter'
     	url = info['urls']['Twitter']
     elsif provider== 'facebook'
     	url = info['urls']['Facebook']
     end
     logger.info "this is info hash #{info.to_json}"
     logger.info "PROFILE URL = #{url}"
     url 
  end 
  

end
