class Event < ApplicationRecord
  #belongs_to :user
  has_many :event_users
  has_many :users, through: :event_users

  validates :name, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, allow_nil: true, length: { maximum: 300 }
  validates :option, presence: true, numericality: { only_integer: true }
  validates :street_address, allow_nil: true, length: { maximum: 50 }, format: {with: /\A[A-Za-z0-9'\.\-\s\,]*\z/}
  validates :apartment_number, allow_nil: true, numericality: { only_integer: true }, length: { maximum: 10 }
  validates :city, allow_nil: true, length: { maximum: 50 }
  validates :password, allow_nil: false, length: { minimum: 5, maximum: 30 }

  validate :date_validate
  validate :time_validate

  def date_validate
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
    if(date.present? && /\A[2-9]\d{3}\p{Pd}[0-1]\d\p{Pd}[0-3]\d\z/ !~ date.to_s)
      errors.add(:date, "format is incorrect.")
      Rails.logger.event.debug("#{date.to_s}")
    end
  end

  def time_validate
    if(time.present? && /\A2000-01-01 [0-2][0-9]:[0-5][0-9]:00 UTC\z/ !~ time.to_s)
      errors.add(:time, "format is incorrect.")
      Rails.logger.event.debug("#{time.to_s}")
    end
  end

end