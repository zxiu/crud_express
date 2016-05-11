class AdminController < ApplicationController
  cruds_expresslize
  before_action :cruds_express_prepare
  def index
  end
end
