module KegAdminController

  def self.included(base)
    base.class_eval do

      include TranslationHelper

      layout        :get_layout
      before_filter :authenticate_admin
      before_filter :load_rpp

      def get_layout
        return (params[:layout]) ? params[:layout] : "admin"
      end

      def destroy_object
        @object = resource
        klass = @object.class.name.underscore.to_sym
        @domid = dom_id(@object)
        @object.destroy
        respond_to do |format|
          format.html { flash[:notice] = I18n.t("inherited_resources.successfully_removed"); redirect_to collection_url }
          format.js
        end
      rescue
      end

      def swap_object
        @object = resource
        @object.swap
        @klass = @object.class.name.underscore.to_sym
        state = @object.state
        @flash_str = I18n.t("state.changed_to", :state => state)
        respond_to do |format|
          format.html { flash[:notice] = @flash_str; redirect_to collection_url }
          format.js
        end
      rescue
      end

      def swap_field
        @object = resource
        field = params[:field]
        @object.update_attribute(field, !@object[field])
        @klass = @object.class.name.underscore.to_sym
        @flash_str = I18n.t("flash.actions.update.notice", :resource_name => t1(@object.class))
        respond_to do |format|
          format.html { flash[:notice] = @flash_str; redirect_to collection_url }
          format.js
        end
      rescue
      end

      def swap_preference
        @object = resource

        pref = params[:pref]

        @object.write_preference(pref, !@object.prefs[pref])
        @object.save(:validate => false)

        @klass = @object.class.name.underscore.to_sym
        @flash_str = I18n.t("flash.actions.update.notice", :resource_name => t1(@object.class))
        respond_to do |format|
          format.html { flash[:notice] = @flash_str; redirect_to collection_url }
          format.js
        end
      rescue
      end

      def set_state_to
        @object = resource
        state = params[:state]

        # TODO
        # check against available states from state_machine

        @object.send(state)
        @klass = @object.class.name.underscore.to_sym
        @flash_str = I18n.t("state.changed_to", :state => tt(@klass, @object.state))
        respond_to do |format|
          format.html { flash[:notice] = @flash_str; redirect_to collection_url }
          format.js
        end
      # rescue
      end

    protected

      def authenticate_admin
        authenticate_user!
        unless user_signed_in? and current_user.admin?
          flash[:error] = I18n.t("errors.messages.permission_denied")
          redirect_to root_url
        end
      end
    end

  end
end
