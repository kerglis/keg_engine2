class UsersController < ApplicationController

  inherit_resources

  before_filter :authenticate_user!
  before_filter :load_resource

  def update
    update!{ user_url }
  end

  def show
    render :edit
  end

protected

  def load_resource
    @user = current_user
  end

end