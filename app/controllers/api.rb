Itelejugito.controllers :api do
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

  get :calls do
       
    @calls = Llamada.where(:account_id => current_account.id)
    @calls.to_json
  end 

  get :call, :with => :id do 
     @call = Llamada.find(:id)
     @call.to_json
  end

  delete :call, :with => :id do
    @call = Llamada.find(:id)
    @call.destroy
  end 
 
  delete :calls, :with => :id do
    @call = Llamada.find(:id)
    @call.destroy
  end

end
