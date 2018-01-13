class Admin::AssetsController < Admin::BaseController
  inherit_resources

  def update
    update! do |success, _failure|
      success.html do
        redirect_to url_for([:edit, :admin, @asset.uploadable])
      end
    end
  end

  def resource
    @crop_style = params[:crop_style]
    @asset = Asset.find(params[:id])
  end
end
