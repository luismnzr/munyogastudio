class FixReservationUniqueIndex < ActiveRecord::Migration[7.0]
  def change
    # Remove the old unique index that prevents rebooking
    remove_index :reservations, name: "index_reservations_on_user_id_and_class_session_id"

    # Add a partial unique index that only applies to confirmed reservations
    add_index :reservations, [:user_id, :class_session_id],
              unique: true,
              where: "status = 'confirmed'",
              name: "index_reservations_on_user_and_session_when_confirmed"
  end
end
