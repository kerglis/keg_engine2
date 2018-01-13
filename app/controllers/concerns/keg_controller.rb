module KegController
  extend ActiveSupport::Concern

  included do
    helper KegEngine2::Engine.helpers

    include SetLocale

    after_filter    :store_location, only: %i[index show]
    before_action   :set_locale
    before_action   :load_rpp
    before_action   :set_user_current

    unless Rails.env.development?
      rescue_from ActiveRecord::RecordNotFound do
        render  file: 'application/err_404',
                layout: 'application',
                status: :not_found
      end
    end

    def store_location
      session[:return_to] = request.path
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def layout
      params[:layout] || 'application'
    end

    def load_rpp
      @rpp = AppConfig[:rpp]
    end

    def destroy_object
      @object = resource
      @klass = @object.class.name.underscore.to_sym
      @object.destroy
      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t('inherited_resources.successfully_removed')
          redirect_to collection_url
        end
        format.js
      end
    rescue StandardError => e
      puts e.message
    end

    def delete_asset(asset_type)
      @object = resource
      @asset_type = asset_type
      @klass = @object.class.name.underscore.to_sym
      asset = @object.send(@asset_type)
      asset.destroy if asset

      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t('inherited_resources.successfully_removed')
          redirect_to edit_resource_url(@object)
        end
        format.js
      end
    rescue StandardError => e
      puts e.message
    end

    def set_user_current
      User.current = current_user if current_user && User.respond_to?(:current=)
    end

    def page_not_found
      respond_to do |format|
        format.html do
          render  template: 'errors/not_found',
                  layout: 'application',
                  status: 404
        end
        format.all do
          render  nothing: true,
                  status: 404
        end
      end
    end

    def server_error
      respond_to do |format|
        format.html do
          render  template: 'errors/server_error',
                  layout: 'application',
                  status: 500
        end
        format.all do
          render  nothing: true,
                  status: 500
        end
      end
    end

    protected

    def render_404(_exception = nil)
      respond_to do |type|
        type.html do
          render  file: Rails.root.join('public/404.html'),
                  status: '404 Not Found'
        end
        type.all do
          render  nothing: true,
                  status: 404
        end
      end
    end
  end
end
