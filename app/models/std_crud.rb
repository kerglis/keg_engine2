module StdCrud

  def self.included(base)

    base.instance_eval do
      load_and_authorize_resource
    end

    base.class_eval do

      def destroy
        destroy_object
      end

      def swap
        swap_object
      end

      def create
        create! do |success, failure|
          success.html do
            resource.try(:send, params[:_state_event]) if params[:_state_event]
            redirect_to edit_resource_url
          end
        end
      end

      def update
        update! do |success, failure|
          success.html do
            resource.try(:send, params[:_state_event]) if params[:_state_event]
            redirect_to edit_resource_url
          end
        end
      end

    end
  end

end