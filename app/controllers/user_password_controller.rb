class UserPasswordController < ApplicationController

  inherit_resources
  defaults resource_class: User, instance_name: 'user'

  before_filter :authenticate_user!
  before_filter :resource

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

end