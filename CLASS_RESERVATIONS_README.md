# Class Reservations Feature

This document describes the new class reservation system added to Mun Yoga Studio.

## Overview

The class reservation system allows:
- **Admins** to schedule yoga classes with customizable capacity
- **Users** to book classes using their purchased class credits
- **Users** to cancel reservations up to 8 hours before class starts (with credit refund)
- Real-time tracking of available spots per class

## Features Implemented

### 1. Database Schema
- **ClassSession** model: Represents scheduled yoga classes
  - Date, start/end time, class type, instructor, capacity, description
- **Reservation** model: Tracks user bookings
  - Links users to class sessions
  - Status tracking (confirmed/cancelled)
  - Cancellation timestamp

### 2. Admin Features
- **Admin Authentication**: Proper admin authorization on all admin routes
- **Class Scheduling Interface** (`/admin/class_sessions`)
  - Create new class sessions with customizable capacity
  - Edit/delete existing sessions
  - View reservations per class
  - See available spots in real-time
- **Pre-defined class types**:
  - Vinyasa flow
  - Slow flow
  - Slow Vinyasa
  - Ashtanga
  - Restaurativo
  - Community Event

### 3. User Features
- **Dynamic Calendar View** (`/calendario`)
  - Shows next 7 days of scheduled classes
  - Real-time availability (spots remaining)
  - One-click booking for users with available class credits
  - Visual indicators for fully booked classes
  - Shows if user already has a reservation
- **My Reservations Page** (`/reservations`)
  - View all upcoming reservations
  - See past class history
  - Cancel reservations (with 8-hour deadline)
  - Visual countdown/warning before cancellation deadline
  - Display remaining class credits

### 4. Business Logic
- **Capacity Management**: Classes enforce maximum capacity
- **Credit System Integration**:
  - Booking a class deducts 1 credit from user balance
  - Cancelling refunds 1 credit (if done >8 hours before class)
- **Validation**:
  - Users can't book the same class twice
  - Users can't book without available credits
  - Users can't book past classes
  - Users can't book full classes
- **Cancellation Rules**:
  - Must cancel at least 8 hours before class start
  - Cancelling late results in loss of class credit

## Setup Instructions

### 1. Install Dependencies
```bash
bundle install
```

### 2. Run Database Migrations
```bash
rails db:migrate
```

This creates the following tables:
- `class_sessions`
- `reservations`

### 3. Create an Admin User
```bash
rails console
user = User.find_by(email: 'your@email.com')
user.update(admin: true)
```

### 4. Start the Rails Server
```bash
rails server
```

## Usage Guide

### For Admins

1. **Access Admin Panel**: Navigate to `/admin`
2. **Schedule Classes**:
   - Click "Schedule New Class"
   - Select class type, date, time, instructor
   - Set capacity (default: 12 students)
   - Optionally add description
3. **Manage Classes**:
   - View all upcoming/past classes
   - Edit class details
   - See who has reserved each class
   - Delete classes if needed

### For Users

1. **View Schedule**: Go to `/calendario` to see available classes
2. **Book a Class**:
   - Ensure you have available class credits (shown at top)
   - Click "Reservar" on desired class
   - Confirmation shown in "Mis Reservas"
3. **Cancel a Reservation**:
   - Go to "Mis Reservas"
   - Click "Cancelar Reserva" on the class
   - Must be done >8 hours before class start
   - Credit automatically refunded to your account

## File Structure

### Models
- `app/models/class_session.rb` - Class scheduling logic
- `app/models/reservation.rb` - Booking and cancellation logic
- `app/models/user.rb` - Updated with reservation associations

### Controllers
- `app/controllers/admin/class_sessions_controller.rb` - Admin CRUD for classes
- `app/controllers/reservations_controller.rb` - User booking/cancellation
- `app/controllers/pages_controller.rb` - Updated calendario with dynamic data
- `app/controllers/admin/application_controller.rb` - Admin authentication

### Views
- `app/views/admin/class_sessions/` - Admin interface
  - `index.html.erb` - List all classes
  - `new.html.erb` / `edit.html.erb` - Create/edit forms
  - `show.html.erb` - Class details with reservations
  - `_form.html.erb` - Form partial
- `app/views/reservations/`
  - `index.html.erb` - User's reservations dashboard
- `app/views/pages/calendario.html.erb` - Updated with dynamic booking

### Migrations
- `db/migrate/20251230000001_create_class_sessions.rb`
- `db/migrate/20251230000002_create_reservations.rb`

### Routes
- `/admin/class_sessions` - Admin class management
- `/calendario` - Public class calendar with booking
- `/reservations` - User reservations management

## Key Business Rules

1. **Class Credits**: Users must purchase class packages to book classes
2. **Capacity**: Each class has a maximum capacity (customizable per class)
3. **Uniqueness**: Users can only book each class once
4. **Cancellation Window**: 8 hours before class start
5. **Credit Refund**: Only if cancelled within allowed timeframe
6. **Past Classes**: Cannot be booked or modified

## Technical Notes

- Uses Rails 7.0.8+ with Hotwire (Turbo/Stimulus)
- PostgreSQL database required
- Ruby 3.1.6
- Integrates with existing Stripe payment system
- Maintains backward compatibility with existing class credit system

## Future Enhancements (Optional)

- Email notifications for bookings/cancellations
- Waitlist functionality for full classes
- Recurring class template creation
- Instructor profiles and user preferences
- Mobile app integration
- Class attendance tracking
- Reports and analytics for admins

## Support

For issues or questions, please contact the development team or file an issue in the repository.
