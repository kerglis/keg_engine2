class Admin::UsersController < Admin::BaseController

  inherit_resources
  include StdCrud

  actions :all, except: [:show]

protected

  def collection
    @search = User.metasearch(@filters)
    @users = @search.paginate( per_page: @rpp, page: params[:page])
  end

end