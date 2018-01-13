module StdCrud
  extend ActiveSupport::Concern

  included do
    load_and_authorize_resource
  end

  def destroy
    destroy_object
  end

  def swap
    swap_object
  end

  def create
    create! do |success, _failure|
      success.html do
        url = params[:redirect_to].presence || edit_resource_url
        resource.try(:send, params[:_state_event]) if params[:_state_event]
        redirect_to url
      end
    end
  end

  def update
    update! do |success, _failure|
      success.html do
        url = params[:redirect_to].presence || edit_resource_url
        resource.try(:send, params[:_state_event]) if params[:_state_event]
        redirect_to url
      end
    end
  end
end
