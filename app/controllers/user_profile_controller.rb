class UserProfileController < ApplicationController

  inherit_resources
  defaults resource_class: User, instance_name: 'user'

  before_filter :authenticate_user!
  before_filter :resource

  actions :show, :edit, :update

  def show
    render :edit
  end

  def update
    update!{ user_path }
  end

private

  def resource
    @user = current_user
  end

end