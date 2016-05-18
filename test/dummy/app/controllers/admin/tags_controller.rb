class Admin::TagsController < ModelController
  cruds_express_roller model: Tag
  cruds_express_collection :list
  before_action :prepare_cruds_express
  around_action :respond_curds_express
  def list
    Tag.all
  end

end
