# Class Reservation System - Setup

Simple implementation of class reservations for Mun Yoga Studio.

## What's Included

- **Admin Interface**: Schedule and manage yoga classes
- **User Booking**: Reserve classes from the calendar
- **Cancellation Policy**: Cancel up to 8 hours before class for credit refund
- **Capacity Management**: Set custom limits per class

## Installation (Simple Steps)

### 1. Run Migrations

```bash
rails db:migrate
```

This creates two new tables:
- `class_sessions` - Scheduled yoga classes
- `reservations` - User bookings

### 2. Create an Admin User

```bash
rails console
```

Then:

```ruby
# Make yourself an admin
user = User.find_by(email: 'your@email.com')
user.update(admin: true)
```

### 3. Start the Server

```bash
rails server
```

## How to Use

### As Admin

1. Go to `/admin` (must be logged in as admin)
2. You'll see "Class Sessions" option
3. Click "Schedule New Class"
4. Fill in:
   - Class type (Vinyasa flow, Slow flow, etc.)
   - Date and time
   - Instructor name
   - Maximum capacity (default: 12)
5. Save

### As User

1. Go to `/calendario` to see all scheduled classes
2. Click "Reservar" to book a class (requires login + available classes)
3. Go to `/reservations` to see your bookings
4. Cancel anytime up to 8 hours before class starts

## Features

✅ **Works with existing setup** - No dependency changes
✅ **Admin scheduling** - Create classes with custom capacity
✅ **User booking** - One-click reservation from calendar
✅ **Smart cancellation** - 8-hour deadline with automatic refund
✅ **Capacity limits** - Classes show available spots
✅ **Credit integration** - Uses existing yogaclass balance

## Routes

### Admin
- `/admin/class_sessions` - Manage scheduled classes

### Users
- `/calendario` - View schedule and book classes
- `/reservations` - Manage your bookings

## Business Logic

1. Users need available classes in their balance to book
2. Booking deducts 1 class from balance
3. Canceling refunds the class (if >8 hours before)
4. Each class has a capacity limit
5. Once full, class shows as "Lleno"

## No Breaking Changes

- ✅ All existing Gemfile dependencies kept
- ✅ Ruby version unchanged (3.1.2)
- ✅ Sass-rails and administrate still work
- ✅ Existing routes and views untouched
- ✅ Backward compatible with current system

## Testing It Out

1. As admin, create a test class for tomorrow
2. As user, book the class from `/calendario`
3. Check `/reservations` to see your booking
4. Try canceling it
5. Verify your class credit was refunded

That's it! Simple and functional.
