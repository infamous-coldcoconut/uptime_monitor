class Site < ApplicationRecord
  has_many :check_results, dependent: :destroy
  enum :status, { pending: "pending", up: "up", down: "down" }, default: :pending

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :url, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :interval_seconds, numericality: { greater_than_or_equal_to: 10 }
  validates :expected_status, numericality: { in: 100..599 }

  scope :due_for_check, -> {
    where("last_checked_at IS NULL OR last_checked_at <= NOW() - (interval_seconds * interval '1 second')") # převádí jednotky na čas
  }
end
