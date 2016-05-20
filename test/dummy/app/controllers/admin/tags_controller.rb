class Admin::TagsController < ModelController
  crud_express role: :model, model: Tag, collection: :list
  around_action :respond_crud_express

  def list
    Tag.all
  end

end
