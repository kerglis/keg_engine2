<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController

  inherit_resources

  include StdCrud

private

  def collection
    @search = <%= class_name %>.search(params[:q])
    @<%= plural_table_name %> = @search.paginate(per_page: @rpp, page: params[:page])
  end

end
<% end -%>