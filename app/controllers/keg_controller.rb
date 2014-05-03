module KegController

  def self.included(base)
    base.class_eval do

      helper KegEngine2::Engine.helpers

      include SetLocale

      layout          :get_layout
      after_filter    :store_location, only: [ :index, :show ]
      before_filter   :set_locale
      before_filter   :load_rpp
      before_filter   :set_user_current

      unless Rails.env.development?
        rescue_from ActiveRecord::RecordNotFound do
          render(file: 'err_404', layout: 'application', status: :not_found )
        end
      end

      def store_location
        session[:return_to] = request.path
      end

      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end

      def get_layout
        return (params[:layout]) ? params[:layout] : "application"
      end

      def load_rpp
        @rpp = AppConfig[:rpp]
      end

      def destroy_object
        # resource - from InheritedResources gem
        @object = resource
        klass = @object.class.name.underscore.to_sym
        # @domid = dom_id(@object)
        @object.destroy
        respond_to do |format|
          format.html { flash[:notice] = I18n.t("inherited_resources.successfully_removed"); redirect_to collection_url }
          format.js
        end
      rescue
      end

      def delete_asset(asset_type)
        @object = resource
        @asset_type = asset_type
        @klass = @object.class.name.underscore.to_sym
        asset = @object.send(@asset_type)
        asset.destroy if asset

        respond_to do |format|
          format.html { flash[:notice] = I18n.t("inherited_resources.successfully_removed"); redirect_to edit_resource_url(@object) }
          format.js
        end
      rescue
      end

      def set_user_current
        User.current = current_user if current_user and User.respond_to?(:current=)
      end

      def page_not_found
        respond_to do |format|
          format.html { render template: 'errors/not_found', layout: 'application', status: 404 }
          format.all  { render nothing: true, status: 404 }
        end
      end

      def server_error
        respond_to do |format|
          format.html { render template: 'errors/server_error', layout: 'application', status: 500 }
          format.all  { render nothing: true, status: 500}
        end
      end

    protected

      def render_404(exception = nil)
        respond_to do |type|
          type.html { render file:    Rail.root.join("public/404.html"), status: "404 Not Found" }
          type.all  { render nothing: true, status: "404 Not Found" }
        end
      end

    end
  end
end
