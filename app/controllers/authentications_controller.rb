class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]

  # Load user's authentications (Twitter, Facebook, ....)
  def index
    @authentications = current_user.authentications if current_user
  end

  # Create an authentication when this is called from the authentication provider callback
  def create
    omniauth = request.env["omniauth.auth"]
    # render :text => omniauth.to_yaml
    
    authentication = Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    if authentication
      # If a user has already signed on with this authentication, just sign the user in.
      flash[:notice] = "You are now signed in."
      sign_in_and_redirect(:user, authentication.user)
    else
      # User is new, create an authentication and a user.
      user = User.create(:username => omniauth['user_info']['nickname'], :email => omniauth['user_info']['email'], :name => omniauth['user_info']['name'])
      auth = user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    
      if auth.save
        flash[:notice] = "Welcome to CraftWiki!"
        sign_in_and_redirect(:user, user)
      else
        flash[:alert] = "Something went wrong during account creation: " + user.errors.full_messages.to_s
        redirect_to(root_url)
      end
    end
  end
end