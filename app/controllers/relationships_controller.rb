class RelationshipsController < ApplicationController

  def create
    # params[:relationship][:followed_id] contains the id of the user to follow;
    # use our functions from the previous exercise to have the current_user 
    # follow them
    respond_to do |format|
      @user = User.find(params[:relationship][:followed_id])
      current_user.follow! @user
    
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    # params[:relationship][:followed_id] contains the id of the user to follow;
    # use our functions from the previous exercise to have the current_user 
    # UNfollow them
    respond_to do |format|
      @user = User.find(params[:relationship][:followed_id])
      current_user.unfollow! @user
      
      format.html { redirect_to @user }
      format.js
    end
  end
end