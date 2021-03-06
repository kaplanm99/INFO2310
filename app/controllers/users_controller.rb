class UsersController < ApplicationController
  
  before_filter :redirect_home_if_signed_in, only: [:new, :create]
  before_filter :redirect_unless_authorized, only: [:edit, :update, :destroy]
  
  
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
		@user = User.find(params[:id])
		@micro_posts = @user.micro_posts.paginate(page: params[:page], per_page: 10)

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @user }
		end
	end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
  
    respond_to do |format|
      if @user.save
	    UserMailer.welcome(@user).deliver
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  private 
    def redirect_unless_authorized
	  @user = User.find(params[:id])
	  # Write some code here that redirects home 
	  # and displays an error message "You are not authorized
	  # to edit that user" if the current_user is not equal to @user
	  unless current_user == @user
		flash[:error] = 'You are not authorized to edit that user'
        redirect_to root_path
	  end
	  
    end
end
