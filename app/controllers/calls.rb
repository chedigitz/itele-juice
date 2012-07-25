Itelejugito.controllers :calls, :parent => :account do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end
  
  get :new do 
     logger.info params.inspect
     params2 =env['rack.request.query_hash']
     logger.info params2.inspect
     
     response =params[:account_id]
     response 
  end 


  post :new do 
    logger.info  "THis is params = #{params.inspect}"
    logger.info "tthis is callstatus #{params["CallStatus"]}"
   
    account_id = params[:account_id]
    #initiaialize call parse object from twilio request
    if params["CallStatus"]=="completed"
      ###if call complete update
      @call = Llamada.find_by_call_uuid(params["CallUUID"])
      @call.update_plivo_call(params)
    
    elsif params["CallStatus"]=="ringing"
      #if call status is renging check to see if call exist in the database
       logger.info "APP IS RINGING!!!!!!!!!"
       @incomming = Llamada.find_by_call_uuid(params["CallUUID"])
       logger.info "this is THE CALL FOUND #{@incomming}"
       if @incomming.nil?   
          #
          #if call does not exist create 
         logger.info "ITS A NEW CALL"
         @call = Llamada.new  
         @call.update_plivo_call(params)
         logger.info "CALL IS = #{@call.inspect}"
         @account = Account.find(account_id)
         logger.info "this is = #{@account.inspect}"
         logger.info "BEGIN ROUTING"
         response = route_call(@call, @account)

          
           
       else
         #call is not found create call in database
         @incomming.update_plivo_call(params)
         response = route_call(@call, @account)
      end
      ##
      # after update to database route call to number
      logger.info "THIS IS RESPONSE BACK TO PLIVEO = #{response.inspect}"
      response
    end
   
  end 

  post :hangup do 
    logger.info params.inspect
    @call = Llamada.find_by_call_uuid(params["CallUUID"])
    logger.info "this is THE CALL FOUND #{@call}"
    @call.update_plivo_call(params)
    logger.info "THIS IS UPDATED CALL #{@call}"
    
    response
     
  end 

  get :hangup do 
    logger.info params.inspect
    response = "test"
    response
     
  end 

  post :sms do 

  end 

  post :dialout do
    logger.info "paramaters passed in #{params.inspect}"
     
  end
  

end
