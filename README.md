# DriveEase — Online Car Rental System (FYP)

A PHP + MySQL web application based on the uploaded Online Car Rental System SRS and SDD. It uses a responsive presentation layer, PHP request/business logic, and a MySQL data-access layer.

## Implemented modules

- Visitor: browse/search available cars, view vehicle details, contact the company, register, sign in.
- Customer: profile-backed account, request reservations, date-overlap availability checks, reservation status tracking, cancel pending requests, submit feedback and see staff replies, view and record demo payment entries.
- Staff: add/update car records, process reservations (confirm, pickup/active, complete/return, cancel/reject), reply to feedback, review contact messages, inspect payment records.
- Administrator: all staff functions plus create staff/admin accounts and toggle staff/admin active status.
- Data model: users/customers, cars, reservations, payments, feedback, contact messages, activity logs.
- Security basics: PDO prepared statements, password hashing, session regeneration, role checks, CSRF tokens, output escaping, active-user check.

## Requirements

- XAMPP for Windows (Apache + PHP 8+ + MySQL/MariaDB), or another PHP/MySQL stack.
- PHP extensions: PDO MySQL and mbstring (typically enabled in XAMPP).
- Internet connection only for remote Google Fonts and optional car image URLs. App logic works locally; car cards show a placeholder when no image URL is available.

## Setup in XAMPP

1. Extract the `car_rental_fyp` folder into `C:\xampp\htdocs\`.
2. Start **Apache** and **MySQL** in XAMPP Control Panel.
3. Open `http://localhost/phpmyadmin`.
4. Choose **Import**, select `database.sql` from this folder, then click **Import/Go**. It creates the `car_rental_fyp` database and tables and inserts a small demo fleet.
5. Open `config.php`. Default XAMPP values are `DB_HOST=127.0.0.1`, `DB_NAME=car_rental_fyp`, `DB_USER=root`, `DB_PASS=''`, and `BASE_URL='/car_rental_fyp'`. Update them if your MySQL password or folder name differs.
6. Visit `http://localhost/car_rental_fyp/setup.php` once. This creates the initial administrator if it does not already exist.
7. Sign in at `http://localhost/car_rental_fyp/login.php` with:
   - Email: `admin@driveease.local`
   - Password: `Admin@12345`
8. **Immediately change or replace this demo administrator password**. This project includes a signed-in change-password page but no email-based password-reset flow. For a class demo, create your own admin/staff account after logging in if needed.
9. Delete `setup.php` after successful setup.

## Quick first-run walkthrough

1. Sign in as admin and open **Management → Fleet inventory**. Add/edit vehicles and rates.
2. Register a customer using a separate email address.
3. As customer, open Explore cars and submit a reservation with pickup and return dates.
4. Sign back in as staff/admin and open **Management → Process reservations**. Confirm the request, then change status to Active for pickup and Completed on return.
5. As customer, open **Payments** (from dashboard navigation may be accessed via `/payments.php`) and save a demo payment record for a confirmed reservation. This only records a sample transaction; it does not collect money.
6. Submit feedback and a contact message as a customer. Review/reply under Management.

## Important implementation notes

- **Payment integration:** SRS/SDD describe payment fields, but do not specify a payment provider, merchant account, or API. The app therefore records clearly labelled demo transactions only. Do not enter card details. To accept real money, select a supported provider and implement its hosted checkout/webhook flow with provider-side verification.
- **Email notifications:** the SRS mentions notifications after registration/reservation/feedback. The current build displays in-app success messages and persists records; it does not send email because no SMTP credentials/service are specified.
- **Car images:** the optional `image_url` field supports externally hosted images. Replace demo image URLs with your own authorized images or leave blank.
- **Reservation conflicts:** the app checks overlapping pending/confirmed/active reservations at submission, and checks overlapping confirmed/active bookings again before staff confirms/activates. For a production deployment, use database transactions/locking to avoid simultaneous-booking races.
- **Password change:** the demo seed setup creates an initial admin account. Remove `setup.php` after setup and use a unique password before showing or deploying the project.
- **Base URL:** if the project folder is not `car_rental_fyp`, update `BASE_URL` in `config.php` accordingly.

## Main routes

- `/index.php` — home
- `/cars.php` — fleet search/list
- `/car.php?id=1` — car details and reservation form
- `/register.php`, `/login.php`, `/logout.php`
- `/dashboard.php` — customer dashboard
- `/change-password.php` — change current account password
- `/feedback.php`, `/contact.php`, `/payments.php`
- `/admin/index.php` — staff/admin dashboard
- `/admin/cars.php`, `/admin/reservations.php`, `/admin/users.php`, `/admin/feedback.php`, `/admin/messages.php`, `/admin/payments.php`

## Testing checklist

- [ ] Register with valid details; duplicate email is rejected.
- [ ] Incorrect login is rejected; correct login works.
- [ ] Visitor cannot reserve until signed in.
- [ ] Invalid date range (return <= pickup) is rejected.
- [ ] Existing overlapping reservation blocks a new reservation.
- [ ] Customer sees only their own reservations, payments, and feedback.
- [ ] Customer cannot access staff/admin routes.
- [ ] Staff can add/edit cars and update rental statuses.
- [ ] Non-admin staff cannot create accounts or delete cars.
- [ ] Admin can create staff accounts.
- [ ] Feedback replies and contact messages appear in customer/staff views.
- [ ] Demo payment creates a record and explicitly does not charge a card.
- [ ] Test responsive layout at mobile, tablet, and desktop widths.

## Suggested FYP submission notes

Use the supplied SRS/SDD as the authoritative requirement source. In the report, label any extra implementation details (activity log, demo payment workflow, status values) as implementation decisions. Before final viva, capture screenshots of the running local system and execute/document the test checklist with actual pass/fail results; do not report tests as passed unless you ran them.
