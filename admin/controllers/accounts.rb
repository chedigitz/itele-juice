Admin.controllers :accounts do

  get :index do
    @accounts = Account.all
    render 'accounts/index'
  end

  get :new do
    @account = Account.new
    render 'accounts/new'
  end

  post :create do
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = "#{mt(Account)} was successfully created."
      redirect url(:accounts, :edit, :id => @account.id)
    else
      flash.now[:error] = "There were some problems creating this #{mt(Account)}."
      render 'accounts/new'
    end
  end

  get :edit, :with => :id do
    @account = Account.find(params[:id])
    render 'accounts/edit'
  end

  put :update, :with => :id do
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = "#{mt(Account)} was successfully updated."
      redirect url(:accounts, :edit, :id => @account.id)
    else
      flash.now[:error] = "There were some problems updating this #{mt(Account)}."
      render 'accounts/edit'
    end
  end

  delete :destroy, :with => :id do
    account = Account.find(params[:id])
    if account != current_account && account.destroy
      flash[:notice] = "#{mt(Account)} was successfully destroyed."
    else
      flash[:error] = 'Unable to destroy #{mt(Account)}!'
    end
    redirect url(:accounts, :index)
  end
end
