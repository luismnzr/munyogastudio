class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :class_session

  validates :user_id, uniqueness: { scope: :class_session_id, message: "already has a reservation for this class" }
  validates :status, presence: true, inclusion: { in: %w[confirmed cancelled] }
  validate :user_has_available_classes, on: :create
  validate :class_has_available_spots, on: :create
  validate :class_not_in_past, on: :create

  scope :confirmed, -> { where(status: 'confirmed') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :upcoming, -> { joins(:class_session).where('class_sessions.date >= ?', Date.today).order('class_sessions.date', 'class_sessions.start_time') }
  scope :past, -> { joins(:class_session).where('class_sessions.date < ?', Date.today).order('class_sessions.date DESC', 'class_sessions.start_time DESC') }

  def can_cancel?
    return false unless status == 'confirmed'
    return false unless class_session.datetime

    # Can cancel if class is more than 8 hours away
    class_session.datetime > 8.hours.from_now
  end

  def cancel!
    if can_cancel?
      transaction do
        update!(status: 'cancelled', cancelled_at: Time.current)
        # Refund the class credit to the user
        user.increment!(:yogaclass)
      end
      true
    else
      errors.add(:base, "Cannot cancel - class starts in less than 8 hours")
      false
    end
  end

  private

  def user_has_available_classes
    if user && user.yogaclass <= 0
      errors.add(:base, "You don't have any available classes. Please purchase a class package.")
    end
  end

  def class_has_available_spots
    if class_session && class_session.full?
      errors.add(:base, "This class is full")
    end
  end

  def class_not_in_past
    if class_session && class_session.datetime && class_session.datetime < Time.current
      errors.add(:base, "Cannot book a class in the past")
    end
  end
end
