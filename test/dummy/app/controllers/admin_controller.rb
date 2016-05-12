class AdminController < ApplicationController
  respond_to :html, :js
  cruds_expresslize
  before_action :prepare_cruds_express


end
