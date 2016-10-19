-- -----------------------------------------------------
-- Schema squadrun
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `squadrun` DEFAULT CHARACTER SET utf8 ;
USE `squadrun` ;

-- -----------------------------------------------------
-- Table `squadrun`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `email` VARCHAR(127) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `username` VARCHAR(127) NULL DEFAULT NULL,
  `active` TINYINT(1) NULL DEFAULT NULL,
  `confirmed_at` DATETIME NULL DEFAULT NULL,
  `last_login_at` DATETIME NULL DEFAULT NULL,
  `current_login_at` DATETIME NULL DEFAULT NULL,
  `last_login_ip` VARCHAR(45) NULL DEFAULT NULL,
  `current_login_ip` VARCHAR(45) NULL DEFAULT NULL,
  `login_count` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`campaign`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`campaign` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `name` VARCHAR(80) NOT NULL,
  `code` VARCHAR(80) NULL DEFAULT NULL,
  `created_by` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `code` (`code` ASC),
  INDEX `created_by` (`created_by` ASC),
  CONSTRAINT `campaign_ibfk_1`
    FOREIGN KEY (`created_by`)
    REFERENCES `squadrun`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`choice_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`choice_group` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `name` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`task_choice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`task_choice` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `choice` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`choice_group_to_choice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`choice_group_to_choice` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `choice_group_id` INT(11) NOT NULL,
  `choice_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `choice_group_id` (`choice_group_id` ASC),
  INDEX `choice_id` (`choice_id` ASC),
  CONSTRAINT `choice_group_to_choice_ibfk_1`
    FOREIGN KEY (`choice_group_id`)
    REFERENCES `squadrun`.`choice_group` (`id`),
  CONSTRAINT `choice_group_to_choice_ibfk_2`
    FOREIGN KEY (`choice_id`)
    REFERENCES `squadrun`.`task_choice` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`question_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`question_type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `name` VARCHAR(80) NOT NULL,
  `parent_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `parent_id` (`parent_id` ASC),
  CONSTRAINT `question_type_ibfk_1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `squadrun`.`question_type` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`task_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`task_type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `name` VARCHAR(80) NOT NULL,
  `parent_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `parent_id` (`parent_id` ASC),
  CONSTRAINT `task_type_ibfk_1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `squadrun`.`task_type` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`task`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`task` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `campaign_id` INT(11) NOT NULL,
  `type` INT(11) NOT NULL,
  `choice_group_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `campaign_id` (`campaign_id` ASC),
  INDEX `choice_group_id` (`choice_group_id` ASC),
  INDEX `type` (`type` ASC),
  CONSTRAINT `task_ibfk_1`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `squadrun`.`campaign` (`id`),
  CONSTRAINT `task_ibfk_2`
    FOREIGN KEY (`choice_group_id`)
    REFERENCES `squadrun`.`choice_group` (`id`),
  CONSTRAINT `task_ibfk_3`
    FOREIGN KEY (`type`)
    REFERENCES `squadrun`.`task_type` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`question` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `question` TEXT NOT NULL,
  `question_type` INT(11) NOT NULL,
  `task_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `question_type` (`question_type` ASC),
  INDEX `task_id` (`task_id` ASC),
  CONSTRAINT `question_ibfk_1`
    FOREIGN KEY (`question_type`)
    REFERENCES `squadrun`.`question_type` (`id`),
  CONSTRAINT `question_ibfk_2`
    FOREIGN KEY (`task_id`)
    REFERENCES `squadrun`.`task` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`role` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`roles_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`roles_users` (
  `user_id` INT(11) NULL DEFAULT NULL,
  `role_id` INT(11) NULL DEFAULT NULL,
  INDEX `role_id` (`role_id` ASC),
  INDEX `user_id` (`user_id` ASC),
  CONSTRAINT `roles_users_ibfk_1`
    FOREIGN KEY (`role_id`)
    REFERENCES `squadrun`.`role` (`id`),
  CONSTRAINT `roles_users_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `squadrun`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`task_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`task_status` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `name` VARCHAR(128) NOT NULL,
  `code` INT(11) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`task_to_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`task_to_user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `task_id` INT(11) NOT NULL,
  `task_status_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `time_left` TIME NULL DEFAULT NULL,
  `start_time` DATETIME NULL DEFAULT NULL,
  `end_time` DATETIME NULL DEFAULT NULL,
  `is_accepted` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `task_id` (`task_id` ASC),
  INDEX `task_status_id` (`task_status_id` ASC),
  INDEX `user_id` (`user_id` ASC),
  CONSTRAINT `task_to_user_ibfk_1`
    FOREIGN KEY (`task_id`)
    REFERENCES `squadrun`.`task` (`id`),
  CONSTRAINT `task_to_user_ibfk_2`
    FOREIGN KEY (`task_status_id`)
    REFERENCES `squadrun`.`task_status` (`id`),
  CONSTRAINT `task_to_user_ibfk_3`
    FOREIGN KEY (`user_id`)
    REFERENCES `squadrun`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`task_user_answer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`task_user_answer` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `task_to_user_id` INT(11) NOT NULL,
  `question_id` INT(11) NOT NULL,
  `choice_id` INT(11) NOT NULL,
  `is_accepted` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `choice_id` (`choice_id` ASC),
  INDEX `question_id` (`question_id` ASC),
  INDEX `task_to_user_id` (`task_to_user_id` ASC),
  CONSTRAINT `task_user_answer_ibfk_1`
    FOREIGN KEY (`choice_id`)
    REFERENCES `squadrun`.`task_choice` (`id`),
  CONSTRAINT `task_user_answer_ibfk_2`
    FOREIGN KEY (`question_id`)
    REFERENCES `squadrun`.`question` (`id`),
  CONSTRAINT `task_user_answer_ibfk_3`
    FOREIGN KEY (`task_to_user_id`)
    REFERENCES `squadrun`.`task_to_user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `squadrun`.`user_profile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `squadrun`.`user_profile` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_on` TIMESTAMP NULL DEFAULT NULL,
  `updated_on` TIMESTAMP NULL DEFAULT NULL,
  `first_name` VARCHAR(255) NULL DEFAULT NULL,
  `last_name` VARCHAR(255) NULL DEFAULT NULL,
  `gender` ENUM('male', 'female', 'ns') NULL DEFAULT NULL,
  `dob` DATETIME NULL DEFAULT NULL,
  `profile_picture` VARCHAR(512) NULL DEFAULT NULL,
  `address` INT(11) NULL DEFAULT NULL,
  `user_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id` (`user_id` ASC),
  CONSTRAINT `user_profile_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `squadrun`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
