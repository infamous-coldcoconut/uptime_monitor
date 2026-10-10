class SchedulePingsJob < ApplicationJob
  queue_as :default

  def perform
    # find všechny weby, které je potřeba zkontrolovat a pak ping
    Site.due_for_check.find_each do |site|
      PingSiteJob.perform_later(site.id)
    end
  end
end
