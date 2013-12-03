class Admin::UsersController < Admin::BaseController

  inherit_resources
  include StdCrud

  actions :all, except: [:show]

protected

  def collection
    @q = User.search(params[:q])
    @users = @q.result(distinct: true)
  end

end