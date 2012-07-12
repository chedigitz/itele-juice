Admin.controllers :llamadas do

  get :index do
    @llamadas = Llamada.all
    render 'llamadas/index'
  end

  get :new do
    @llamada = Llamada.new
    render 'llamadas/new'
  end

  post :create do
    @llamada = Llamada.new(params[:llamada])
    if @llamada.save
      flash[:notice] = "#{mt(Llamada)} was successfully created."
      redirect url(:llamadas, :edit, :id => @llamada.id)
    else
      flash.now[:error] = "There were some problems creating this #{mt(Llamada)}."
      render 'llamadas/new'
    end
  end

  get :edit, :with => :id do
    @llamada = Llamada.find(params[:id])
    render 'llamadas/edit'
  end

  put :update, :with => :id do
    @llamada = Llamada.find(params[:id])
    if @llamada.update_attributes(params[:llamada])
      flash[:notice] = "#{mt(Llamada)} was successfully updated."
      redirect url(:llamadas, :edit, :id => @llamada.id)
    else
      flash.now[:error] = "There were some problems updating this #{mt(Llamada)}."
      render 'llamadas/edit'
    end
  end

  delete :destroy, :with => :id do
    llamada = Llamada.find(params[:id])
    if llamada.destroy
      flash[:notice] = "#{mt(Llamada)} was successfully destroyed."
    else
      flash[:error] = 'Unable to destroy #{mt(Llamada)}!'
    end
    redirect url(:llamadas, :index)
  end
end
