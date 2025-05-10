class Note < ApplicationRecord
  belongs_to :notebook

  validates :title, presence: true
  validates :content, presence: true
end
