DROP DATABASE IF EXISTS `project`;
CREATE DATABASE `project` DEFAULT CHARACTER SET utf8mb4;
USE `project`;


-- -----------------------------------------------------
-- Table: Parent
-- -----------------------------------------------------
DROP TABLE IF EXISTS `project`.`parent`;
CREATE TABLE IF NOT EXISTS `project`.`parent` (
  `cnic` VARCHAR(15) NOT NULL,
  `father_occupation` VARCHAR(100) NULL,
  `phone_number` VARCHAR(20) NULL,
  PRIMARY KEY (`cnic`)
) ENGINE = InnoDB;
INSERT INTO parent (cnic, father_occupation, phone_number)
VALUES 
('12345-1234567-1', 'Teacher', '03001234567'),
('12345-1234567-2', 'Businessman', '03009876543');


-- -----------------------------------------------------
-- Table: Student
-- -----------------------------------------------------
DROP TABLE IF EXISTS `project`.`student`;
CREATE TABLE IF NOT EXISTS `project`.`student` (
  `reg_no` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `father_name` VARCHAR(100) NULL,
  `cnic` VARCHAR(15) NULL,
  `address` VARCHAR(255) NULL,
  `parent_cnic` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`reg_no`),
  INDEX `fk_student_parent_idx` (`parent_cnic` ASC),
  CONSTRAINT `fk_student_parent`
    FOREIGN KEY (`parent_cnic`)
    REFERENCES `project`.`parent` (`cnic`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;
INSERT INTO student (reg_no, name, father_name, cnic, address, parent_cnic)
VALUES 
(1, 'Ali Raza', 'Ahmed Raza', '35201-1234567-8', 'Lahore', '12345-1234567-1'),
(2, 'Sara Khan', 'Imran Khan', '35202-9876543-2', 'Karachi', '12345-1234567-2');

-- -----------------------------------------------------
-- Table: Fee
-- -----------------------------------------------------
DROP TABLE IF EXISTS `project`.`fee`;
CREATE TABLE IF NOT EXISTS `project`.`fee` (
  `voucher_no` INT NOT NULL,
  `reg_no` INT NULL,
  `total_fee` DECIMAL(10,2) NULL,
  `pending_fee` DECIMAL(10,2) NULL,
  `date` DATE NULL,
  `student_reg_no` INT NOT NULL,
  PRIMARY KEY (`voucher_no`),
  INDEX `fk_fee_student_idx` (`student_reg_no` ASC),
  CONSTRAINT `fk_fee_student`
    FOREIGN KEY (`student_reg_no`)
    REFERENCES `project`.`student` (`reg_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;
INSERT INTO fee (voucher_no, reg_no, total_fee, pending_fee, date, student_reg_no)
VALUES 
(1001, 1, 5000.00, 1000.00, '2025-04-01', 1),
(1002, 2, 5000.00, 0.00, '2025-04-01', 2);

-- -----------------------------------------------------
-- Table: Teacher
-- -----------------------------------------------------
DROP TABLE IF EXISTS `project`.`teacher`;
CREATE TABLE IF NOT EXISTS `project`.`teacher` (
  `teacher_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `subject` VARCHAR(100) NOT NULL,
  `phone_no` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`teacher_id`),
  UNIQUE INDEX `email_unique` (`email` ASC)
) ENGINE = InnoDB;
INSERT INTO teacher (name, subject, phone_no, email)
VALUES 
('Miss Fatima', 'Math', '03001112233', 'fatima@school.edu.pk'),
('Sir Zain', 'English', '03112223344', 'zain@school.edu.pk');

-- -----------------------------------------------------
-- Table: Results
-- -----------------------------------------------------
DROP TABLE IF EXISTS `project`.`results`;
CREATE TABLE IF NOT EXISTS `project`.`results` (
  `result_id` INT NOT NULL AUTO_INCREMENT,
  `subject_name` VARCHAR(100) NOT NULL,
  `max_marks` INT NULL,
  `marks_obtained` INT NULL,
  `total_marks` INT NULL,
  `max_percentage` DECIMAL(5,2) NULL,
  `remarks` VARCHAR(100) NULL,
  `student_reg_no` INT NOT NULL,
  `teacher_id` INT NOT NULL,
  PRIMARY KEY (`result_id`),
  INDEX `fk_results_student_idx` (`student_reg_no` ASC),
  INDEX `fk_results_teacher_idx` (`teacher_id` ASC),
  CONSTRAINT `fk_results_student`
    FOREIGN KEY (`student_reg_no`)
    REFERENCES `project`.`student` (`reg_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_results_teacher`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `project`.`teacher` (`teacher_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;
INSERT INTO results (subject_name, max_marks, marks_obtained, total_marks, max_percentage, remarks, student_reg_no, teacher_id)
VALUES 
('Math', 100, 85, 100, 85.00, 'Good', 1, 1),
('English', 100, 70, 100, 70.00, 'Satisfactory', 2, 2);

-- -----------------------------------------------------
-- Table: Attendance
-- -----------------------------------------------------
DROP TABLE IF EXISTS `project`.`attendance`;
CREATE TABLE IF NOT EXISTS `project`.`attendance` (
  `attendance_id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NULL,
  `status` ENUM('Present', 'Absent', 'Late') NOT NULL,
  `student_reg_no` INT NOT NULL,
  `teacher_id` INT NOT NULL,
  PRIMARY KEY (`attendance_id`),
  INDEX `fk_attendance_student_idx` (`student_reg_no` ASC),
  INDEX `fk_attendance_teacher_idx` (`teacher_id` ASC),
  CONSTRAINT `fk_attendance_student`
    FOREIGN KEY (`student_reg_no`)
    REFERENCES `project`.`student` (`reg_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_attendance_teacher`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `project`.`teacher` (`teacher_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;
INSERT INTO attendance (date, status, student_reg_no, teacher_id)
VALUES 
('2025-04-14', 'Present', 1, 1),
('2025-04-14', 'Absent', 2, 2);


-- 1. Show all students and their parent info
SELECT s.reg_no, s.name, p.father_occupation, p.phone_number
FROM student s
JOIN parent p ON s.parent_cnic = p.cnic;

-- 2. Show student attendance with teacher who marked it
SELECT s.name AS student, a.date, a.status, t.name AS teacher
FROM attendance a
JOIN student s ON s.reg_no = a.student_reg_no
JOIN teacher t ON t.teacher_id = a.teacher_id;

-- 3. Show students with pending fees
SELECT s.name, f.total_fee, f.pending_fee
FROM student s
JOIN fee f ON s.reg_no = f.student_reg_no
WHERE f.pending_fee > 0;




