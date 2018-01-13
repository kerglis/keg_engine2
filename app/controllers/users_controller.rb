class UsersController < ApplicationController
  inherit_resources

  before_action :authenticate_user!

  def update
    update! { user_url }
  end

  def show
    resource
    render :edit
  end

  private

  def resource
    @user = current_user
  end

  def permitted_params
    params.permit(user: User.permitted_params)
  end
end
