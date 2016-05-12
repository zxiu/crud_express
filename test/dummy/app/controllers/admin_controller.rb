class AdminController < ApplicationController
  respond_to :html, :js
  cruds_expresslize
  before_action :cruds_express_prepare

end
