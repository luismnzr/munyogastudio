require "administrate/base_dashboard"

class ClassSessionDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    class_type: Field::String,
    date: Field::Date,
    start_time: Field::Time,
    end_time: Field::Time,
    instructor_name: Field::String,
    capacity: Field::Number,
    description: Field::Text,
    reservations: Field::HasMany,
    users: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    date
    start_time
    class_type
    instructor_name
    capacity
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    class_type
    date
    start_time
    end_time
    instructor_name
    capacity
    description
    reservations
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    class_type
    date
    start_time
    end_time
    instructor_name
    capacity
    description
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(class_session)
    "#{class_session.class_type} - #{class_session.date}"
  end
end
