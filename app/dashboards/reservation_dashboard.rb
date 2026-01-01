require "administrate/base_dashboard"

class ReservationDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    user: Field::BelongsTo,
    class_session: Field::BelongsTo,
    status: Field::String,
    cancelled_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    user
    class_session
    status
    created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    user
    class_session
    status
    cancelled_at
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    user
    class_session
    status
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(reservation)
    "Reservation ##{reservation.id}"
  end
end
