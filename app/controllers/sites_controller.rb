class SitesController < ApplicationController
  def index
    @sites = Site.order(created_at: :desc)
    @site = Site.new
  end

  def create
    @site = Site.new(site_params)
    # hned se pošle ping po přidání
    if @site.save
      PingSiteJob.perform_later(@site.id)
      redirect_to root_path, notice: "Web is on watchlist on blacklist and redlist lol"
    else
      @sites = Site.order(created_at: :desc)
      render :index, status: :unprocessable_entity # statusu 422, validace not good
    end
  end

  def destroy
    site = Site.find(params[:id])
    site.destroy
    redirect_to root_path, notice: "Web has been taken in to custody and to jail aka delete"
  end

  private

  # Bezpečnostní filtr
  def site_params
    params.require(:site).permit(:name, :url, :interval_seconds, :expected_status)
  end
end
