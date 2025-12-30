class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:cancel, :destroy]

  def index
    @upcoming_reservations = current_user.reservations.confirmed.upcoming.includes(:class_session)
    @past_reservations = current_user.reservations.past.includes(:class_session).limit(10)
  end

  def create
    @class_session = ClassSession.find(params[:class_session_id])
    @reservation = current_user.reservations.build(
      class_session: @class_session,
      status: 'confirmed'
    )

    if @reservation.save
      # Deduct a class from the user's balance
      current_user.decrement!(:yogaclass)
      redirect_to reservations_path, notice: 'Class booked successfully!'
    else
      redirect_to calendario_path, alert: @reservation.errors.full_messages.join(', ')
    end
  end

  def cancel
    if @reservation.cancel!
      redirect_to reservations_path, notice: 'Reservation cancelled successfully. Your class credit has been refunded.'
    else
      redirect_to reservations_path, alert: @reservation.errors.full_messages.join(', ')
    end
  end

  def destroy
    if @reservation.cancel!
      redirect_to reservations_path, notice: 'Reservation cancelled successfully. Your class credit has been refunded.'
    else
      redirect_to reservations_path, alert: @reservation.errors.full_messages.join(', ')
    end
  end

  private

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end
end
