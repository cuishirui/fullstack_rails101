class Account::PostsController < ApplicationController

  def index
    @posts = current_user.posts.recent
  end

  def edit
    @group = Group.find(params[:group_id])
    @post  = Post.find(params[:id])
    @post.group = @group
  end
end
