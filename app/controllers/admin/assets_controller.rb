class Admin::AssetsController < Admin::BaseController

  inherit_resources

  def update
    update! do |success, failure|
      success.html { redirect_to url_for([ :edit, :admin, @asset.uploadable ]) }
    end
  end

  def resource
    @crop_style = params[:crop_style]
    @asset = Asset.find(params[:id])
  end

end