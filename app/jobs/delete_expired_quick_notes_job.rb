class DeleteExpiredQuickNotesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    expired_notes = QuickNote.where("expires_at < ?", Time.current).destroy_all
    deleted_notes = expired_notes.size
    Rails.logger.info("[DeleteExpiredQuickNotesJob] Deleted #{deleted_notes} expired quick notes at #{Time.current}.")
  end
end
