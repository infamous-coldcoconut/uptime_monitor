class PingSiteJob < ApplicationJob
  queue_as :default

  def perform(site_id)
    site = Site.find_by(id: site_id)
    # unless == opak if, takže něco jako !if/neplatí podmínka
    # pokračuj dále, ALE vrať se pokud tuhle podmíňku nesplnuješ
    return unless site

    result = Sites::Pinger.call(site)

    # uložení/aktualizace v 1 transakci, crazyy
    ApplicationRecord.transaction do
      site.check_results.create!(
        status_code: result.status_code,
        response_time_ms: result.response_time_ms,
        successful: result.success,
        error_message: result.error_message
      )

      # Aktualizace status a čas posledního měření
      new_status = result.success ? :up : :down
      site.update!(
        status: new_status,
        last_checked_at: Time.current
      )
    end

    # Real-time vysílání do prohlížečů pro auto update stránky
    site.broadcast_replace_to(
      "sites",
      target: site,
      partial: "sites/site",
      locals: { site: site }
    )
  end
end
