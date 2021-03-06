class CommentsController < ApplicationController

  before_action :set_post
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :vote]
  before_action :access_denied, only:[:vote,:show, :create]


  def index

  end

  def create
    @comment = Comment.new(comment_params)
    @comment.post = @post
    @comment.user = current_user

    if @comment.save 
      flash[:notice] = 'Comment was added!'
      redirect_to post_path(@post)
    else
      @comments = @post.comments
      render 'posts/show'
    end
  end

  def vote
    @already_voted = already_voted?(@comment)
    if @already_voted
      @message = 'You already voted in this comment.'
    else
      Vote.create(voteable:@comment,creator:current_user,vote:params[:vote])
      @message = nil
    end

    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
      params.require(:comment).permit(:body)
  end

  def set_post
    @post = Post.find_by(slug:params[:post_id])
  end
  
end