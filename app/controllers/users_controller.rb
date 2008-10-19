class UsersController < ApplicationController
   skip_before_filter :verify_authenticity_token, :only => :create
   
   # Displays the new user form.
   def new
      @user = User.new
   end
   
   # Creates a new TechReach user.
   def create
      logout_keeping_session!
      if using_open_id?
         authenticate_with_open_id(params[:openid_url], :return_to => open_id_create_url, 
                                   :required => [:nickname, :email]) do |result, identity_url, registration|
            if result.successful?
               create_new_user(:identity_url => identity_url, :email => registration['email'])
            else
               failed_creation(result.message || "Sorry, something went wrong")
            end
         end
      else
         create_new_user(params[:user])
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
   
   protected
   
   # Actually creates the new user account. Redirects them to an interim screen where they can
   # fill out the rest of their profile if successful.
   def create_new_user(attributes)
      @user = User.new(attributes)
      if @user && @user.valid_for_attributes?([:email, :password, :password_confirmation])
         if @user.not_using_openid?
            @user.register!
         else
            @user.register_openid!
         end
      end
      
      if @user.errors.empty?
         # All good. Set the new user as the current user in the session, 
         # effectively logging them in.
         self.current_user = @user
         
         # Redirect them to the iterim signup page.
         redirect_to(new_user_user_url(@user))
      else
         failed_creation
      end
   end
   
   def failed_creation(message = 'Sorry, there was an error creating your account')
      flash[:error] = message
      render :action => :new
   end
end
