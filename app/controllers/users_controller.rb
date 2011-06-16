class UsersController < ApplicationController

 before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
 before_filter :correct_user, :only => [:edit, :update]
 before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
 
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])    
    @title = @user.name    
  end

  def new
    redirect_to(root_path) if signed_in?
    @user = User.new
    @title = "Sign up"
  end
  
  def create
#    sign_out if signed_in?  
    redirect_to(root_path) if signed_in?
    @user = User.new(params[:user])
    if @user.save
      sign_in @user    
      flash[:success] = "Welcome to the Sample App!"      
      redirect_to @user
    else
      @title = "Sign up"
      # BEGIN Percy edit...
      @user.password = ""
      @user.password_confirmation = ""    
      #  END  Percy edit...
      render 'new'
    end
  end

  def edit
 #   @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
 #   @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    foundUser = User.find(params[:id])
    if current_user?(foundUser) 
      flash[:notice] = "Admin User can not destroy themself."
    else
      foundUser.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end
  
  private

#    def authenticate
#      deny_access unless signed_in?
#    end  

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end  

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
