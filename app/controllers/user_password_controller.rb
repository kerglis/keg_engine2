class UserPasswordController < ApplicationController
  inherit_resources
  defaults resource_class: User, instance_name: 'user'

  before_action :authenticate_user!
  before_action :resource

  actions :show, :edit, :update

  def show
    render :edit
  end

  def update
    update! do |format|
      if resource.errors.empty?
        sign_in resource, bypass: true
        format.html { redirect_to user_path }
      end
    end
  end

  private

  def resource
    @user = current_user
  end

  def permitted_params
    params.permit(user: User.permitted_params)
  end
end
