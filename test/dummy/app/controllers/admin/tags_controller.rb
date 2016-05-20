class Admin::TagsController < ModelController
  crud_express role: :model, model: Tag, collection: :list

  def list
    Tag.all.page(params[:page]).per(20)
  end

end
