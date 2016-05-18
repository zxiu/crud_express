class AdminController < ApplicationController
  # respond_to :html, :js
  crud_express_roller :admin
  # before_action :init_locals
  before_action :prepare_crud_express

  add_model User, controller: 'admin/users'
  add_model Article, controller: 'admin/articles'
  add_model Tag, controller: 'admin/tags'

end
