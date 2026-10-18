CREATE DATABASE IF NOT EXISTS car_rental_fyp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE car_rental_fyp;

CREATE TABLE IF NOT EXISTS users (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(120) NOT NULL,
 email VARCHAR(190) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 phone VARCHAR(40) NULL,
 cnic VARCHAR(30) NULL,
 address TEXT NULL,
 role ENUM('customer','staff','admin') NOT NULL DEFAULT 'customer',
 is_active TINYINT(1) NOT NULL DEFAULT 1,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cars (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(120) NOT NULL,
 model VARCHAR(100) NOT NULL,
 color VARCHAR(50) NOT NULL,
 registration_no VARCHAR(40) NOT NULL UNIQUE,
 rate_per_day DECIMAL(12,2) NOT NULL,
 transmission ENUM('Automatic','Manual') NOT NULL DEFAULT 'Automatic',
 seats TINYINT UNSIGNED NOT NULL DEFAULT 5,
 status ENUM('available','maintenance','unavailable') NOT NULL DEFAULT 'available',
 image_url VARCHAR(500) NULL,
 description TEXT NULL,
 created_by INT UNSIGNED NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_cars_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reservations (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 customer_id INT UNSIGNED NOT NULL,
 car_id INT UNSIGNED NOT NULL,
 pickup_date DATE NOT NULL,
 return_date DATE NOT NULL,
 pickup_location VARCHAR(255) NOT NULL,
 driver_required TINYINT(1) NOT NULL DEFAULT 0,
 days SMALLINT UNSIGNED NOT NULL,
 total_amount DECIMAL(12,2) NOT NULL,
 status ENUM('pending','confirmed','active','completed','cancelled','rejected') NOT NULL DEFAULT 'pending',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
 INDEX idx_reservation_car_dates (car_id,pickup_date,return_date,status),
 INDEX idx_reservation_customer (customer_id,created_at),
 CONSTRAINT fk_reservation_customer FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE RESTRICT,
 CONSTRAINT fk_reservation_car FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payments (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 reservation_id INT UNSIGNED NOT NULL,
 customer_id INT UNSIGNED NOT NULL,
 car_id INT UNSIGNED NOT NULL,
 transaction_id VARCHAR(60) NOT NULL UNIQUE,
 transaction_type VARCHAR(80) NOT NULL,
 amount DECIMAL(12,2) NOT NULL,
 status ENUM('recorded','pending','failed','refunded') NOT NULL DEFAULT 'recorded',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_payment_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE RESTRICT,
 CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE RESTRICT,
 CONSTRAINT fk_payment_car FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS feedback (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 customer_id INT UNSIGNED NOT NULL,
 title VARCHAR(180) NOT NULL,
 feedback_type ENUM('General','Suggestion','Complaint','Compliment') NOT NULL DEFAULT 'General',
 description TEXT NOT NULL,
 staff_reply TEXT NULL,
 replied_by INT UNSIGNED NULL,
 replied_at DATETIME NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_feedback_customer FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
 CONSTRAINT fk_feedback_staff FOREIGN KEY (replied_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS contact_messages (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 name VARCHAR(120) NOT NULL,
 email VARCHAR(190) NOT NULL,
 subject VARCHAR(180) NOT NULL,
 message TEXT NOT NULL,
 status ENUM('new','read','closed') NOT NULL DEFAULT 'new',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_message_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS activity_logs (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 action VARCHAR(255) NOT NULL,
 ip_address VARCHAR(45) NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX idx_activity_user (user_id,created_at),
 CONSTRAINT fk_activity_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Demo fleet. These rows are inserted only when the fleet table is empty.
INSERT INTO cars (name,model,color,registration_no,rate_per_day,transmission,seats,status,image_url,description)
SELECT * FROM (
 SELECT 'Toyota Corolla','2023 Altis','Pearl White','DEMO-001',9500.00,'Automatic',5,'available','https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?auto=format&fit=crop&w=1000&q=80','Comfortable and dependable sedan for city trips and longer drives.' UNION ALL
 SELECT 'Honda Civic','2022 Oriel','Metallic Grey','DEMO-002',12500.00,'Automatic',5,'available','https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1000&q=80','A refined sedan with a sporty feel and a comfortable cabin.' UNION ALL
 SELECT 'Suzuki Swift','2024 GLX','Fiery Red','DEMO-003',6500.00,'Automatic',5,'available','https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=1000&q=80','Compact and easy to drive, ideal for daily errands and city travel.'
) AS demo WHERE NOT EXISTS (SELECT 1 FROM cars LIMIT 1);

-- Default admin is created by setup.php, which hashes the password securely.
