class KeepActiveJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Perform a basic query to simulate activity
    count = User.count
    Rails.logger.info("[KeepActiveJob] Total users: #{count}")
  end
end
