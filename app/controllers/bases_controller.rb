class BasesController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update, :index, :show, :destroy]
  before_action :set_base, only: [:edit, :update, :destroy]
  

  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点情報を作成しました。'  
      redirect_to bases_url
    else
      flash[:danger] = "拠点情報の作成に失敗しました。" + @base.errors.full_messages.join("<br>")
      redirect_to bases_url
    end
  end
  
  def edit
  end

  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to bases_url
    else
      flash[:danger] = "拠点情報の更新に失敗しました。" + @base.errors.full_messages.join("<br>")
      redirect_to bases_url
    end
  end
  
  def index
    @bases = Base.all
  end
  
  def show
  end
  
  def destroy
    if @base.destroy
      flash[:success] = "拠点情報を消去しました。"
      redirect_to bases_url
    else
    end
  end
  
  private
  
    def set_base
      @base = Base.find(params[:id])
    end
    
    def base_params
      params.require(:base).permit(:base_number, :base_name, :information)
    end
end