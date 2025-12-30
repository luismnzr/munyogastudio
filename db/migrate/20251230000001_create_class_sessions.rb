class CreateClassSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :class_sessions do |t|
      t.string :class_type, null: false
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :instructor_name
      t.integer :capacity, default: 12, null: false
      t.text :description

      t.timestamps
    end

    add_index :class_sessions, [:date, :start_time]
  end
end
