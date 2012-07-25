Admin.controllers :numbers do

  get :index do
    
    @numbers = Number.where("account_id" => current_account.id)
    render 'numbers/index'
  end

  get :new do
    @number = Number.new
    render 'numbers/new'
  end

  post :create do
    @number = Number.new(params[:number])
    if @number.save
      flash[:notice] = "#{mt(Number)} was successfully created."
      redirect url(:numbers, :edit, :id => @number.id)
    else
      flash.now[:error] = "There were some problems creating this #{mt(Number)}."
      render 'numbers/new'
    end
  end

  get :edit, :with => :id do
    @number = Number.find(params[:id])
    logger.info "NUMBER = #{@number.inspect}"
    render 'numbers/edit'
  end

  put :update, :with => :id do
    @number = Number.find(params[:id])
    if @number.update_attributes(params[:number])
      flash[:notice] = "#{mt(Number)} was successfully updated."
      redirect url(:numbers, :edit, :id => @number.id)
    else
      flash.now[:error] = "There were some problems updating this #{mt(Number)}."
      render 'numbers/edit'
    end
  end

  delete :destroy, :with => :id do
    number = Number.find(params[:id])
    if number.destroy
      flash[:notice] = "#{mt(Number)} was successfully destroyed."
    else
      flash[:error] = 'Unable to destroy #{mt(Number)}!'
    end
    redirect url(:numbers, :index)
  end
end
