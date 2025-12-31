# Installation Guide

This guide will help you set up and run the Mun Yoga Studio application locally.

## Prerequisites

- **Ruby**: 3.1.6 (managed via rbenv or similar)
- **Rails**: 7.0.8+
- **PostgreSQL**: 9.5 or higher
- **Node.js**: For JavaScript asset management (via importmap)

## System Dependencies

The application has been optimized to avoid native extension compilation issues. **No build tools required** - the sassc dependency has been removed.

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/luismnzr/munyogastudio.git
cd munyogastudio
```

### 2. Install Ruby Dependencies

```bash
bundle install
```

This should complete without errors. If you encounter any issues, ensure you have PostgreSQL client libraries:

**Ubuntu/Debian:**
```bash
sudo apt-get install libpq-dev
```

**macOS:**
```bash
brew install postgresql
```

### 3. Set Up Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env  # If you have an example file
# OR create manually:
touch .env
```

Add your configuration:

```env
# Database
DATABASE_URL=postgresql://localhost/munyogastudio_development

# Stripe (for payments)
STRIPE_PUBLISH_KEY=your_publishable_key
STRIPE_SECRET_KEY=your_secret_key
WEBHOOK_KEY=your_webhook_key

# Mailtrap (for emails in development)
MAILTRAP_API_TOKEN=your_mailtrap_token
```

### 4. Create and Set Up the Database

```bash
# Create the database
rails db:create

# Run migrations
rails db:migrate
```

### 5. Create an Admin User

```bash
rails console
```

In the Rails console:

```ruby
# Create a new user
user = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'Admin User',
  admin: true
)

# Or make an existing user an admin
user = User.find_by(email: 'your@email.com')
user.update(admin: true)
```

### 6. Start the Rails Server

```bash
rails server
```

The application will be available at `http://localhost:3000`

## Accessing the Application

### Public Pages
- **Home**: `http://localhost:3000/`
- **Calendar**: `http://localhost:3000/calendario`
- **Payments**: `http://localhost:3000/payments/new`

### User Pages (require login)
- **My Reservations**: `http://localhost:3000/reservations`
- **My Account**: `http://localhost:3000/users/edit`

### Admin Pages (require admin user)
- **Admin Dashboard**: `http://localhost:3000/admin`
- **Class Management**: `http://localhost:3000/admin/class_sessions`
- **User Management**: `http://localhost:3000/admin/users`

## Seed Data (Optional)

To populate the database with sample classes:

```bash
rails console
```

```ruby
# Create sample classes for the next week
7.times do |day|
  date = Date.today + day.days

  # Morning class
  ClassSession.create!(
    class_type: 'Vinyasa flow',
    date: date,
    start_time: '07:00',
    end_time: '08:15',
    instructor_name: 'Luis Manzur',
    capacity: 12,
    description: 'Energizing morning flow'
  )

  # Evening class
  ClassSession.create!(
    class_type: 'Slow flow',
    date: date,
    start_time: '18:00',
    end_time: '19:15',
    instructor_name: 'Paola Arzola',
    capacity: 15,
    description: 'Relaxing evening practice'
  )
end
```

## Testing the Reservation System

1. **As Admin**:
   - Log in as your admin user
   - Go to `/admin/class_sessions`
   - Create a new class session
   - Set date, time, class type, capacity

2. **As Regular User**:
   - Create a new user account (or use existing)
   - Make sure user has available classes (update via admin panel or console)
   - Go to `/calendario`
   - Book a class by clicking "Reservar"
   - View your reservations at `/reservations`

3. **Test Cancellation**:
   - From `/reservations`, cancel a booking
   - Verify the class credit is refunded
   - Try cancelling a class within 8 hours (should fail)

## Troubleshooting

### Bundle install fails

If you get errors during `bundle install`:

1. **PostgreSQL gem (pg) fails**:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install libpq-dev

   # macOS
   brew install postgresql
   ```

2. **General native extension errors**:
   The application has been updated to remove dependencies on sassc and other problematic gems. If you cloned an older version, pull the latest changes.

### Database connection errors

1. Make sure PostgreSQL is running:
   ```bash
   # Check status
   sudo service postgresql status

   # Start if needed
   sudo service postgresql start
   ```

2. Verify your database configuration in `config/database.yml`

3. Check DATABASE_URL in `.env` if you're using one

### Admin panel shows 403/Access Denied

Make sure your user has admin privileges:

```bash
rails console
User.find_by(email: 'your@email.com').update(admin: true)
```

### Stripe webhooks not working

In development, use Stripe CLI to forward webhooks:

```bash
stripe listen --forward-to localhost:3000/webhooks
```

## Next Steps

- Review `CLASS_RESERVATIONS_README.md` for detailed feature documentation
- Set up Stripe products and prices for class packages
- Configure email sending for production
- Set up a production database
- Deploy to your hosting platform

## Support

For issues or questions:
- Check the documentation in the `docs/` folder
- Review `CLASS_RESERVATIONS_README.md` for reservation system details
- File an issue on GitHub
