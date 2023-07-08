class MembersOnlyArticlesController < ApplicationController
  before_action :authorize_user

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find_by(id: params[:id], is_member_only: true)
  
    if article
      render json: article, only: [:id, :title, :content], status: :ok
    else
      render json: { error: 'Article not found' }, status: :not_found
    end
  end

  private

  def authorize_user
    return if session[:user_id].present?
  
    render json: { error: 'Not authorized'}, status: :unauthorized
  end
end

