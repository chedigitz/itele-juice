Itelejugito.controllers :dial do
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

  post :answer do
    logger.info "paramaters passed in #{params.inspect}"
     logger.info  "THis is params = #{params.inspect}"
    logger.info "tthis is callstatus #{params["CallStatus"]}"

    phone_num = Phone.find_by_number(params["From"])
    account = phone_num.account 
    logger.info "this is account #{account.inspect}"
    @call = Llamada.new
    @call.update_outgoing_call(params) 
   
    response = call_out(@call, account)
    logger.info "THIS IS RESPONSE BACK TO PLIVEO = #{response.inspect}"
    response

    
  end
  
  post :hangup do 
    logger.info "parameters passed in #{params.inspect}"

    logger.info params.inspect
    @call = Llamada.find_by_call_uuid(params["CallUUID"])
    logger.info "this is THE CALL FOUND #{@call}"
    @call.update_plivo_call(params)
    logger.info "THIS IS UPDATED CALL #{@call}"
    
    response
  end


end
