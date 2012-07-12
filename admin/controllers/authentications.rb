Admin.controllers :authentications do

  get :index do
    @authentications = current_account.authentications
    logger.debug current_account.to_json
    logger.debug current_account.authentications.to_json
    render 'authentications/index'
  end

  get :new do
    @authentication = Authentication.new
    render 'authentications/new'
  end

   get :create do 
     omniauth = request.env["omniauth.auth"]
     logger.info  omniauth
      authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      if authentication
        flash[:notice] = "Signed in Successfully"
        #aawesome sign in goes here
      elsif current_account
        current_account.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
        flash[:notice] = "Authentication Successful"
        #
      else
        @account = Account.new(:name => omniauth["info"]["name"], :email => omniauth["info"]["email"])
        @account.authentications.build(:provider => omniauth["provider"], :uid => omniauth["uid"])
        @account.save!
        #awesome redirect 
      end
      
    end

  get :edit, :with => :id do
    @authentication = Authentication.find(params[:id])
    render 'authentications/edit'
  end

  put :update, :with => :id do
    @authentication = Authentication.find(params[:id])
    if @authentication.update_attributes(params[:authentication])
      flash[:notice] = "#{mt(Authentication)} was successfully updated."
      redirect url(:authentications, :edit, :id => @authentication.id)
    else
      flash.now[:error] = "There were some problems updating this #{mt(Authentication)}."
      render 'authentications/edit'
    end
  end

  delete :destroy, :with => :id do
    authentication = Authentication.find(params[:id])
    if authentication.destroy
      flash[:notice] = "#{mt(Authentication)} was successfully destroyed."
    else
      flash[:error] = 'Unable to destroy #{mt(Authentication)}!'
    end
    redirect url(:authentications, :index)
  end
end
