class DeleteExpiredQuickNotesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    QuickNote.where("expires_at < ?", Time.current).destroy_all
  end
end
