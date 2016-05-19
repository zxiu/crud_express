class AdminController < ApplicationController
  crud_express role: :admin, controllers: [Admin::UsersController, Admin::ArticlesController, Admin::TagsController]
end
