class Event < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 300 }
  validates :option, presence: true, numericality: { only_integer: true }
  validates :street_address, length: { maximum: 100 }
  validates :apartment_number, numericality: { only_integer: true }, length: { maximum: 10 }
  validates :city, length: { maximum: 100 }
  validates :date, format: { with: /\A[0-1][0-9]\/[0-3][0-9]\/[2][0-9]{3}\z/, message: "Enter numbers for the date please." }
  validates :time, format: { with: /\A[0-1][0-9]\:[0-5][0-9][ ][AP][M]\z/, message: "Enter proper time format please." }
  validates :name, presence: true, length: { minimum: 5, maximum: 100 }
end
