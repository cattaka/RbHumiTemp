class HumitempsController < ApplicationController
  before_action :set_humitemp, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  protect_from_forgery :except => :create

  # GET /humitemps
  # GET /humitemps.json
  def index
    @humitemps = Humitemp.all
  end

  # GET /humitemps/1
  # GET /humitemps/1.json
  def show
  end

  # GET /humitemps/new
  def new
    @humitemp = Humitemp.new
  end

  # GET /humitemps/1/edit
  def edit
  end

  # POST /humitemps
  # POST /humitemps.json
  def create
    @humitemp = Humitemp.new(humitemp_params)

    @humitemp.box = Box.find_by_access_token(params[:humitemp][:access_token])
binding.pry
    respond_to do |format|
      if @humitemp.save
        format.html { redirect_to @humitemp, notice: 'Humitemp was successfully created.' }
        format.json { render :show, status: :created, location: @humitemp }
      else
        format.html { render :new }
        format.json { render json: @humitemp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /humitemps/1
  # PATCH/PUT /humitemps/1.json
  def update
    respond_to do |format|
      if @humitemp.update(humitemp_params)
        format.html { redirect_to @humitemp, notice: 'Humitemp was successfully updated.' }
        format.json { render :show, status: :ok, location: @humitemp }
      else
        format.html { render :edit }
        format.json { render json: @humitemp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /humitemps/1
  # DELETE /humitemps/1.json
  def destroy
    @humitemp.destroy
    respond_to do |format|
      format.html { redirect_to humitemps_url, notice: 'Humitemp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_humitemp
      @humitemp = Humitemp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def humitemp_params
      params.require(:humitemp).permit(:humidity, :temperature, :measured_at, :created_at, :box_id)
    end
end