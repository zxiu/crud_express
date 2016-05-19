class AdminController < ApplicationController
  # respond_to :html, :js
  crud_express role: :admin, controllers: [Admin::UsersController, Admin::ArticlesController, Admin::TagsController]
  crud_express_role :admin
  # crud_express role: :admin, controllers: []
  # before_action :prepare_crud_express

  add_model User, controller: 'admin/users'
  add_model Article, controller: 'admin/articles'
  add_model Tag, controller: 'admin/tags'

end
