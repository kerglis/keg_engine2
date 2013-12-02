class Admin::UsersController < Admin::BaseController

  inherit_resources

  actions :all, except: [:show]

  def destroy
    destroy_object
  end

  def swap
    swap_object
  end

protected

  def collection
    load_filters
    @search = User.metasearch(@filters)
    @collection = @search.paginate( per_page: @rpp, page: params[:page])
  end

end