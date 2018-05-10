module StdCrud
  extend ActiveSupport::Concern

  included do
    load_and_authorize_resource param_method: :param_sanitizer
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

  private

  def resource_type
    resource_class.to_s.underscore.to_sym
  end

  def param_sanitizer
    params
      .require(resource_type)
      .permit(resource_class.try(:permitted_params))
  end

  def permitted_params
    params.permit(resource_type => resource_class.try(:permitted_params))
  end
end
