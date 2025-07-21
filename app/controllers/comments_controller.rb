class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: "Comment added successfully."
    else
      render "posts/show", status: :unprocessable_entity
    end
  end

  def show
    # Nothing needed here—@comment and @post already set
  end

  def edit
    # Nothing needed here—@comment already set
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_comment_path(@post, @comment), notice: "Comment updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy
      redirect_to @post, notice: "Comment deleted."
    else
      redirect_to @post, alert: "Failed to delete comment."
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
    unless @post
      redirect_to posts_path, alert: "Post not found." and return
    end
  end

  def set_comment
    @comment = @post.comments.find_by(id: params[:id])
    unless @comment
      redirect_to @post, alert: "Comment not found." and return
    end
  end

  def authorize_user!
    unless current_user == @comment.user || current_user&.admin?
      redirect_to @post, alert: "You are not authorized to perform this action." and return
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
