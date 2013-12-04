class Admin::UsersController < Admin::BaseController

  inherit_resources
  include StdCrud

  actions :all, except: [:show]

protected

  def collection
    @q = User.search(params[:q])
    @users = @q.result(distinct: true).paginate(page: params[:page], per_page: 20)
  end

  def permitted_params
    params.permit( user: User.permitted_params )
  end

end