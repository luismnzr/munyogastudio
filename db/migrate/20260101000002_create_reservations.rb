class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :class_session, null: false, foreign_key: true
      t.string :status, default: 'confirmed', null: false
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :reservations, [:user_id, :class_session_id], unique: true
    add_index :reservations, [:class_session_id, :status]
  end
end
