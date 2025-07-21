class ReactionsController < ApplicationController
  before_action :find_post
  before_action :retrieve_reaction, only: [ :update, :destroy ]

  def create
    respond_to do |format|
      return if has_reacted?
      @reaction = Reaction.new(reaction_params)
      if @reaction.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace("reaction_frame_#{@post.id}", partial: "posts/reaction", locals: { reactions: @post.reactions, post: @post, reaction: @reaction }) }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash[:alert] = "You have already reacted to this post"
      end
    end
  end
  def update
    respond_to do |format|
      if @reaction.update(reaction_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("reaction_frame_#{@post.id}", partial: "posts/reaction", locals: { reactions: @post.reactions, post: @post, reaction: @reaction }) }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash[:alert] = "Cannot update reaction"
      end
    end
  end

  def destroy
    respond_to do |format|
      if @reaction.destroy
        format.turbo_stream { render turbo_stream: turbo_stream.replace("reaction_frame_#{@post.id}", partial: "posts/reaction", locals: { reactions: @post.reactions, post: @post, reaction: nil }) }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash[:alert] = "Cannot delete reaction"
      end
    end
  end

  private

  def reaction_params
    params.require(:reaction).permit(:reaction).merge(user_id: current_user.id, post_id: @post.id)
  end

  def retrieve_reaction
    @reaction = @post.reactions.find(params[:id])
    redirect_to root_path, alert: "reaction does not exist" unless @reaction
  end

  def find_post
    @post = Post.find(params[:post_id])
    redirect_to root_path, alert: "post does not exist" unless @post
  end

  def has_reacted?
    !Reaction.find_by(user_id: reaction_params[:user_id], post_id: reaction_params[:post_id]).nil?
  end
end
