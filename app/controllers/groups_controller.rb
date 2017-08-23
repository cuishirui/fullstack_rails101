class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_group_and_check_permission, only: [:update, :edit, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      @group.save
      redirect_to groups_path
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path
  end

  def show
    @group = Group.find(params[:id])
    @post = Post.new

    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 9)
  end

  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "joined this group"
    else
      flash[:warning] = "You alread is groups member"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:danger] = "quit this group"
    else
      flashp[:warning] = "You are not this group member, can't quit"
    end

    redirect_to group_path(@group)
  end


  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "you have no permission"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)

  end
end
