class RimClassesController < ApplicationController
  before_filter :find_classes
  def index
  end

  def show
    @rim_class = RimClass.find(params[:id])
  end
  private
  def find_classes
    @rim_classes = RimClass.all
  end
end
