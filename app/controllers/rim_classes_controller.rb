class RimClassesController < ApplicationController
  before_filter :find_classes
  def index
  end

  def show
    @rim_class = RimClass.find(params[:id])
    respond_to do |format|
      format.xml  {render :xml => @rim_class.xml}
      format.html
    end
  end
  private
  def find_classes
    @rim_classes = RimClass.all
  end
end
