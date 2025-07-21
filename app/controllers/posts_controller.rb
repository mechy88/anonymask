class PostsController < ApplicationController
  before_action :retrieve_post, only: [ :show, :edit, :update, :destroy, :mark_seen, :mark_resolved ]
  skip_before_action :authenticate_user!, only: [ :show, :index ]
  before_action :admin_only!, only: [ :mark_seen, :mark_resolved ]
  before_action :authorize_post_owner!, only: [ :edit, :update, :destroy ]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      redirect_to edit_post_path(@post), status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  def mark_seen
    @post.update(status: :seen)
    redirect_to @post
  end

  def mark_resolved
    @post.update(status: :resolved)
    redirect_to @post
  end

  private

  def post_params
    params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
  end

  def retrieve_post
    @post = Post.find_by(id: params[:id])
    unless @post
      redirect_to posts_path, alert: "Post does not exist" and return
    end
  end

  def authorize_post_owner!
    unless @post.user_id == current_user.id || current_user.admin?
      redirect_to posts_path, alert: "You are not authorized to perform this action." and return
    end
  end
end
