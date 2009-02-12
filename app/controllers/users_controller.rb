class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :login_required, :only => [:new_user, :update_new_user]
  
  # Displays the new user form.
  def new
    @user = User.new
  end
  
  # Actually creates the new TechReach user account. Redirects them to an interim screen where they can
  # fill out the rest of their profile if successful.
  def create
    logout_keeping_session!
    
    @user = User.new(params[:user])
    @user.roles << Role.find(params[:role])
    puts @user.inspect
    if @user && @user.valid_for_attributes?([:email, :password, :password_confirmation])
      @user.register!
    end
    
    if @user.errors.empty?
      # All good. Set the new user as the current user in the session, 
      # effectively logging them in.
      self.current_user = @user
      
      # Redirect them to the iterim signup page.
      redirect_to(new_user_user_url(@user))
    else
      flash[:error] = 'Sorry, there was an error creating your account'
      render :action => :new
    end
  end
  
  # The user is redirected to this action after successfully creating an account. At this point, they've
  # only supplied an email address and password, and an activation email has been sent. This screen will
  # let the new user know about the email activation and provide them with a way to fill out the more
  # important parts of their profile (e.g. first name, last name).
  def new_user
    @user = User.find_by_id(params[:id])
  end
  
  # Handles the updating of the more important profile fields after a user has just signed up for a new
  # account.
  def update_new_user
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to(login_url)
    else
      render(:action => :new_user)
    end
  end
  
  # Activates a pending user account. Typically the user receives an email with a link to follow that
  # contains the activation code.
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
      when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to login_path
      when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default(root_path)
    end
  end
  
  private
  
  # Returns true if the current user's id is the same as the id of the user trying to be edited.
  def authorized?
    current_user && current_user.id == params[:id].to_i
  end
end
