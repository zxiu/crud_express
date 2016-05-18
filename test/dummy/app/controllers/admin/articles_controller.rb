class Admin::ArticlesController < ModelController
  cruds_express_roller model: Article, includes: [:user, :tags]
  cruds_express_entries :article_list
  before_action :prepare_cruds_express
  around_action :respond_curds_express
  def article_list
    Article.includes(:user).includes(:tags).all
  end

end
