Admin.controllers :phones do

  get :index do
    @phones = current_account.phones
    render 'phones/index'
  end

  get :new do
    @phone = Phone.new
    render 'phones/new'
  end

  post :create do
    @phone = Phone.new(params[:phone])
    if @phone.save
      flash[:notice] = "#{mt(Phone)} was successfully created."
      redirect url(:phones, :edit, :id => @phone.id)
    else
      flash.now[:error] = "There were some problems creating this #{mt(Phone)}."
      render 'phones/new'
    end
  end

  get :edit, :with => :id do
    @phone = Phone.find(params[:id])
    render 'phones/edit'
  end

  put :update, :with => :id do
    @phone = Phone.find(params[:id])
    if @phone.update_attributes(params[:phone])
      flash[:notice] = "#{mt(Phone)} was successfully updated."
      redirect url(:phones, :edit, :id => @phone.id)
    else
      flash.now[:error] = "There were some problems updating this #{mt(Phone)}."
      render 'phones/edit'
    end
  end

  delete :destroy, :with => :id do
    phone = Phone.find(params[:id])
    if phone.destroy
      flash[:notice] = "#{mt(Phone)} was successfully destroyed."
    else
      flash[:error] = 'Unable to destroy #{mt(Phone)}!'
    end
    redirect url(:phones, :index)
  end
end
