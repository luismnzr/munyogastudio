namespace :classes do
  desc "Populate calendar with sample class sessions for the next month"
  task populate: :environment do
    puts "Populating class sessions for the next 30 days..."

    # Define daily schedule (same every day)
    daily_schedule = [
      { time: "07:00", type: "Vinyasa Flow", duration: 75 },
      { time: "08:25", type: "Hatha Yoga", duration: 60 },
      { time: "09:30", type: "Yin Yoga", duration: 60 },
      { time: "18:15", type: "Power Yoga", duration: 65 },
      { time: "19:30", type: "Restorative Yoga", duration: 60 }
    ]

    # Extra class for Tuesdays and Thursdays
    tuesday_thursday_extra = { time: "11:00", type: "Vinyasa Flow", duration: 60 }

    # Instructors to rotate
    instructors = ["Ana García", "Luis Martínez", "María López"]

    start_date = Date.today
    end_date = start_date + 30.days
    created_count = 0

    # Iterate through each date
    (start_date..end_date).each do |date|
      # Add daily classes
      daily_schedule.each_with_index do |slot, index|
        start_time = Time.zone.parse("#{date} #{slot[:time]}")
        end_time = start_time + slot[:duration].minutes
        instructor = instructors[index % instructors.length]

        # Check if class already exists
        unless ClassSession.exists?(date: date, start_time: start_time)
          ClassSession.create!(
            class_type: slot[:type],
            date: date,
            start_time: start_time,
            end_time: end_time,
            instructor_name: instructor,
            capacity: 15,
            description: "#{slot[:type]} class with #{instructor}"
          )
          created_count += 1
        end
      end

      # Add extra class for Tuesdays (2) and Thursdays (4)
      if date.cwday == 2 || date.cwday == 4
        start_time = Time.zone.parse("#{date} #{tuesday_thursday_extra[:time]}")
        end_time = start_time + tuesday_thursday_extra[:duration].minutes
        instructor = instructors[0]

        unless ClassSession.exists?(date: date, start_time: start_time)
          ClassSession.create!(
            class_type: tuesday_thursday_extra[:type],
            date: date,
            start_time: start_time,
            end_time: end_time,
            instructor_name: instructor,
            capacity: 15,
            description: "#{tuesday_thursday_extra[:type]} class with #{instructor}"
          )
          created_count += 1
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