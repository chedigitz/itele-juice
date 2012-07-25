# Helper methods defined here can be accessed in any controller or view in the application

Itelejugito.helpers do
  # def simple_helper_method
  #  ...
  # end

  def call_out(call, account)
     
      # if rank_call(call) < 60
        # r = Response.new()
        # r.addWait({'length' => 2})
        # r.addSpeak('Sorry, but the number you are trying to reach is now disconnected. Please check the number, and try again. Goodbye')
        # response = r.to_xml()
      
      # elsif rank_call(call) > 60
        #check number size to make sure its enought digits

        if call.to_number.length == 10
          call.to_number = "1#{call.to_number}"  
        end 
        
        r = Response.new()
        d = r.addDial({'callerId' => account.caller_id})
        logger.info "BUILDING RESPONSE #{r.inspect}"
        d.addNumber(call.to_number)
        logger.info "BUILDING RESPONSE #{r.inspect}"
        response = r.to_xml()
      # end  
    response
  end
end
