class DropOldReservationTables < ActiveRecord::Migration[7.0]
  def up
    drop_table :reservations, if_exists: true
    drop_table :class_sessions, if_exists: true
  end

  def down
    # Can't reverse this easily, but that's okay - we're recreating them right after
  end
end
