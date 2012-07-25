class Llamada
  include MongoMapper::Document

  # key <name>, <type>
  key :subaccount, String
  key :call_direction, String
  key :from_number, String
  key :to_number, String
  key :bill_rate, Float
  key :event, String
  key :call_uuid, String
  key :ring_count, Integer
  key :status, String
  key :account_id, ObjectId
  key :ring_count, Integer, :default => 1

  timestamps!

  belongs_to :account
  def update_plivo_call(plivo_call)
    ###
    ##accepts a plivo call object respose and updates the attributes
    logger.info "ENTERED THE UPDATE PROCESS"   
    self.call_direction = plivo_call["Direction"]
    self.from_number = plivo_call["From"]
    self.bill_rate = plivo_call["BillRate"]
    self.to_number= plivo_call["To"]
    self.call_uuid = plivo_call["CallUUID"]
    self.event = plivo_call["Event"]
    self.status = plivo_call["CallStatus"]
    
    if self.status == "ringing" 
      ## if call is rining increment the total ring count
      self.ring_count += self.ring_count
    end 
    self.account_id = get_account_id(to_number)
    self.save 

  end 
  
  def get_account_id(to_n)
    ##this method retrieves the account id by searching for the numbers 
   
       # call is from a number
       num = Phone.find_by_number(to_n)
       account_id = num.account_id 
    
    account_id
  end

  def update_outgoing_call(plivo_call)
   # this method updates the outgoing call 
       ###
    ##accepts a plivo call object respose and updates the attributes
    logger.info "ENTERED THE UPDATE PROCESS"   
    self.call_direction = plivo_call["Direction"]
    self.from_number = plivo_call["From"]
    self.bill_rate = plivo_call["BillRate"]
    self.to_number= plivo_call["To"]
    self.call_uuid = plivo_call["CallUUID"]
    self.event = plivo_call["Event"]
    self.status = plivo_call["CallStatus"]
    
    if self.status == "ringing" 
      ## if call is rining increment the total ring count
      self.ring_count += self.ring_count
    end 
    self.account_id = get_account_id(from_number)
    self.save 

  end
 

end
