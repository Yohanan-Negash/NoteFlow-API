class QuickNote < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  before_create :set_expiry

  private
  def set_expiry
    self.expires_at = 24.hours.from_now
  end
end
