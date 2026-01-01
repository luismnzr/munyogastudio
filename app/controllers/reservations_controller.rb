class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @upcoming_reservations = current_user.reservations.confirmed.upcoming.includes(:class_session)
  end

  def create
    @class_session = ClassSession.find(params[:class_session_id])
    @reservation = current_user.reservations.build(class_session: @class_session, status: 'confirmed')

    if @reservation.save
      current_user.decrement!(:yogaclass)
      redirect_to reservations_path, notice: 'Class booked successfully!'
    else
      redirect_to calendario_path, alert: @reservation.errors.full_messages.join(', ')
    end
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])
    if @reservation.cancel!
      redirect_to reservations_path, notice: 'Reservation cancelled. Credit refunded.'
    else
      redirect_to reservations_path, alert: @reservation.errors.full_messages.join(', ')
    end
  end
end
