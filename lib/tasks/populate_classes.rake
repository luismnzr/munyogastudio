namespace :classes do
  desc "Populate calendar with sample class sessions for the next month"
  task populate: :environment do
    puts "Populating class sessions for the next 30 days..."

    # Define class schedule (weekly pattern)
    schedule = [
      { day: 1, time: "09:00", type: "Vinyasa Flow", instructor: "Ana García", duration: 60 },      # Monday morning
      { day: 1, time: "18:30", type: "Hatha Yoga", instructor: "Luis Martínez", duration: 75 },     # Monday evening
      { day: 3, time: "10:00", type: "Yin Yoga", instructor: "Ana García", duration: 90 },          # Wednesday morning
      { day: 3, time: "19:00", type: "Vinyasa Flow", instructor: "Luis Martínez", duration: 60 },   # Wednesday evening
      { day: 5, time: "09:00", type: "Hatha Yoga", instructor: "Ana García", duration: 75 },        # Friday morning
      { day: 5, time: "18:00", type: "Power Yoga", instructor: "Luis Martínez", duration: 60 },     # Friday evening
      { day: 6, time: "10:30", type: "Restorative Yoga", instructor: "Ana García", duration: 75 }   # Saturday morning
    ]

    start_date = Date.today
    end_date = start_date + 30.days
    created_count = 0

    # Iterate through each week
    (start_date..end_date).each do |date|
      schedule.each do |slot|
        # Check if this date matches the day of week (1=Monday, 7=Sunday)
        if date.cwday == slot[:day]
          start_time = Time.zone.parse("#{date} #{slot[:time]}")
          end_time = start_time + slot[:duration].minutes

          # Check if class already exists
          unless ClassSession.exists?(date: date, start_time: start_time)
            ClassSession.create!(
              class_type: slot[:type],
              date: date,
              start_time: start_time,
              end_time: end_time,
              instructor_name: slot[:instructor],
              capacity: 12,
              description: "#{slot[:type]} class with #{slot[:instructor]}"
            )
            created_count += 1
          end
        end
      end
    end

    puts "✓ Created #{created_count} class sessions"
    puts "Calendar populated from #{start_date} to #{end_date}"
  end

  desc "Clear all future class sessions (use with caution!)"
  task clear_future: :environment do
    count = ClassSession.where("date >= ?", Date.today).count
    print "This will delete #{count} future class sessions. Are you sure? (yes/no): "

    # In production, you'll need to manually confirm
    # For safety, this won't auto-confirm
    puts "\nRun ClassSession.where('date >= ?', Date.today).destroy_all in console to confirm"
  end
end
