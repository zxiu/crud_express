class Admin::ArticlesController < ModelController
  cruds_express_roller model: Article, includes: {user: {label: :first_name}, :tags => {label: :name}}
  cruds_express_collection :article_list
  before_action :prepare_cruds_express
  around_action :respond_curds_express
  def article_list
    Article.includes(:tags).all
  end

end
