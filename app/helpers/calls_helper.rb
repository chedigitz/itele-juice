# Helper methods defined here can be accessed in any controller or view in the application

Itelejugito.helpers do
  # def simple_helper_method
  #  ...
  # end

  def transfer_to_phones(account)
    ##
    # make an plivo api call to transfer call to given number
  	auth_id = account.plivo_authsid
  	auth_token = AUTH_TOKEN
  	call_detail = {
  		"legs" => 'aleg'

  	}

  	client = Plivo::RestAPI.new(auth_id, auth_token)
  	response = client.transfer_call(call_detail)
  end

  def rank_call(call)
     rank = 70
     rank 
  end 

  def route_call(call, account)
     
      if rank_call(call) < 60
        r = Response.new()
        r.addWait({'length' => 2})
        r.addSpeak('Sorry, but the number you are trying to reach is now disconnected. Please check the number, and try again. Goodbye')
        response = r.to_xml()
      
      elsif rank_call(call) > 60
        r = Response.new()
        d = r.addDial({'callerId' => call.from_number})
        logger.info "BUILDING RESPONSE #{r.inspect}"
        logger.info "ADDING NUMBERs #{account.active_phones.inspect}"
        d.addNumber(account.active_phones)
        logger.info "BUILDING RESPONSE #{r.inspect}"
        response = r.to_xml()
      end  
    response
  end

end
