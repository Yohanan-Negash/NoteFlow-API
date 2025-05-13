class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :quick_notes, dependent: :destroy
  has_many :notebooks, dependent: :destroy
  # has_many :notes, through: :notebooks

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
