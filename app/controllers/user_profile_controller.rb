class UserProfileController < ApplicationController
  inherit_resources

  defaults resource_class: User, instance_name: 'user'

  before_action :authenticate_user!
  before_action :resource

  actions :show, :edit, :update

  def show
    render :edit
  end

  def update
    update! { user_path }
  end

  private

  def resource
    @user = current_user
  end

  def permitted_params
    params.permit(user: User.permitted_params)
  end
end
