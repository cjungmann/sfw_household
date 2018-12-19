SET default_storage_engine=InnoDB;

CREATE TABLE IF NOT EXISTS Household
(
   id    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   name  VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS Person
(
   id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   id_household INT UNSIGNED NOT NULL,
   fname        VARCHAR(20),
   lname        VARCHAR(40),

   INDEX(id_household),
   FOREIGN KEY (id_household) REFERENCES Household(id)
);
