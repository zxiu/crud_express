class AdminController < ApplicationController
  # respond_to :html, :js
  cruds_express_roller :admin
  # before_action :init_locals
  before_action :prepare_cruds_express

  add_model User, controller: 'admin/users'
  add_model Article, controller: 'admin/articles'


end
