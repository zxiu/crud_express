class Admin::TagsController < ModelController
  crud_express_roller model: Tag
  crud_express_collection :list
  before_action :prepare_crud_express
  around_action :respond_crud_express
  def list
    Tag.all
  end

end
