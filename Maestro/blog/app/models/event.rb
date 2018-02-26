class Event < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 300 }
  validates :option, presence: true, numericality: { only_integer: true }
  validates :street_address, length: { maximum: 100 }
  validates :apartment_number, presence: false, allow_nil: true, numericality: { only_integer: true }, length: { maximum: 10 }
  validates :city, length: { maximum: 100 }
  #validates :date, allow_nil: true#, format: { with: /\A[2][0-9]{3}\-[0-1][0-9]\-[0-3][0-9]\z/, message: "Enter proper numbers please. Year must be after 1999." }
  validates :time, allow_nil: true, format: { with: /\A[0-2][0-9]:[0-5][0-9]\z/, message: "format is incorrect." }  #[-\+][0-9]{4} or [0-9]{4}-[0-9]{2}-[0-9]{2}[0-2][0-9]:[0-5][0-9]:[0-5][0-9] UTC
  validates :name, presence: true, length: { minimum: 5, maximum: 100 }
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
end
