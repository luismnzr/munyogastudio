class ClassSession < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations

  validates :class_type, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  scope :upcoming, -> { where('date >= ?', Date.today).order(:date, :start_time) }
  scope :on_date, ->(date) { where(date: date).order(:start_time) }

  def available_spots
    capacity - reservations.where(status: 'confirmed').count
  end

  def full?
    available_spots <= 0
  end

  def datetime
    return nil unless date && start_time
    Time.use_zone('America/Monterrey') do
      Time.zone.local(date.year, date.month, date.day, start_time.hour, start_time.min)
    end
  end
end
