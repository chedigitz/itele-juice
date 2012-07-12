Admin.controllers :plivoapps do

  get :index do
    @plivoapps = Plivoapp.all
    render 'plivoapps/index'
  end

  get :new do
    @plivoapp = Plivoapp.new
    render 'plivoapps/new'
  end

  post :create do
    @plivoapp = Plivoapp.new(params[:plivoapp])
    if @plivoapp.save
      flash[:notice] = "#{mt(Plivoapp)} was successfully created."
      redirect url(:plivoapps, :edit, :id => @plivoapp.id)
    else
      flash.now[:error] = "There were some problems creating this #{mt(Plivoapp)}."
      render 'plivoapps/new'
    end
  end

  get :edit, :with => :id do
    @plivoapp = Plivoapp.find(params[:id])
    render 'plivoapps/edit'
  end

  put :update, :with => :id do
    @plivoapp = Plivoapp.find(params[:id])
    if @plivoapp.update_attributes(params[:plivoapp])
      flash[:notice] = "#{mt(Plivoapp)} was successfully updated."
      redirect url(:plivoapps, :edit, :id => @plivoapp.id)
    else
      flash.now[:error] = "There were some problems updating this #{mt(Plivoapp)}."
      render 'plivoapps/edit'
    end
  end

  delete :destroy, :with => :id do
    plivoapp = Plivoapp.find(params[:id])
    if plivoapp.destroy
      flash[:notice] = "#{mt(Plivoapp)} was successfully destroyed."
    else
      flash[:error] = 'Unable to destroy #{mt(Plivoapp)}!'
    end
    redirect url(:plivoapps, :index)
  end
end
