Admin.controllers :tunnels do

  get :index do
    @tunnels = Tunnel.all
    render 'tunnels/index'
  end

  get :new do
    @tunnel = Tunnel.new
    render 'tunnels/new'
  end

  post :create do
    @tunnel = Tunnel.new(params[:tunnel])
    if @tunnel.save
      flash[:notice] = "#{mt(Tunnel)} was successfully created."
      redirect url(:tunnels, :edit, :id => @tunnel.id)
    else
      flash.now[:error] = "There were some problems creating this #{mt(Tunnel)}."
      render 'tunnels/new'
    end
  end

  get :edit, :with => :id do
    @tunnel = Tunnel.find(params[:id])
    render 'tunnels/edit'
  end

  put :update, :with => :id do
    @tunnel = Tunnel.find(params[:id])
    if @tunnel.update_attributes(params[:tunnel])
      flash[:notice] = "#{mt(Tunnel)} was successfully updated."
      redirect url(:tunnels, :edit, :id => @tunnel.id)
    else
      flash.now[:error] = "There were some problems updating this #{mt(Tunnel)}."
      render 'tunnels/edit'
    end
  end

  delete :destroy, :with => :id do
    tunnel = Tunnel.find(params[:id])
    if tunnel.destroy
      flash[:notice] = "#{mt(Tunnel)} was successfully destroyed."
    else
      flash[:error] = 'Unable to destroy #{mt(Tunnel)}!'
    end
    redirect url(:tunnels, :index)
  end
end
