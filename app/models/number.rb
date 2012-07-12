class Number
  include MongoMapper::Document

  # key <name>, <type>
  key :voice_enabled, Boolean
  key :description, String
  key :plivo_number, Boolean
  key :sms_enabled, Boolean
  key :num, String
  key :application, String
  key :number_type, String
  key :added_on, Date
  key :resource_uri, String
  key :account_id, ObjectId
  key :plivoapp_id, ObjectId
  timestamps!
   
  belongs_to :account
  belongs_to :plivoapp
 
   before_save :plivo_get_number
   before_save :add_to_plivoapp

  ##this method retrieves the phone number from plivo 
  #
  private

  def update_required 
    resource_uri.blank?
  end

  def plivo_get_number()  
    info = {
      'number' => self.number 
    }
    c = Plivo::RestAPI.new(AUTH_ID, AUTH_TOKEN)
    response = c.get_number(info)
    logger.info "REPONSE for get number = #{response[1]["objects"]}"
    objects = response[1]["objects"][0]
    
    update(objects)

  end 

  def update(numberObject)
    self.voice_enabled = numberObject["voice_enabled"]
    self.description = numberObject["description"]
    self.plivo_number = numberObject["plivo_number"]
    self.sms_enabled = numberObject["sms_enabled"]
    self.num = numberObject["number"]
    self.application = numberObject["application"]
    self.number_type = numberObject["number_type"]
    self.added_on = numberObject["added_on"]
    self.resource_uri = numberObject["resource_uri"]
  end

   def add_to_plivoapp
    plivoapp = Plivoapp.find(plivoapp_id)
    plivoapp.numbers << self
    plivoapp.save!

  end

  def remove_from_plivoapp
    [Plivoapp.pull({:number_ids => id}, {:number_ids => id})]
    
  end

end
