USE SFW_Households;
DELIMITER $$

-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Type1_List $$
CREATE PROCEDURE App_Person_Type1_List(id_household INT UNSIGNED,
                                       id INT UNSIGNED)
BEGIN
   SELECT p.id,
          p.fname,
          p.lname
     FROM Person p
    WHERE p.id_household = id_household
      AND (id IS NULL OR p.id = id);
END  $$


-- ---------------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Type1_Add $$
CREATE PROCEDURE App_Person_Type1_Add(id_household INT UNSIGNED,
                                      fname VARCHAR(20),
                                      lname VARCHAR(40))
BEGIN
   DECLARE newid INT UNSIGNED;
   DECLARE rcount INT UNSIGNED;

   INSERT INTO Person
          (id_household, 
           fname, 
           lname)
   VALUES (id_household, 
           fname, 
           lname);

   SELECT ROW_COUNT() INTO rcount;
   IF rcount > 0 THEN
      SET newid = LAST_INSERT_ID();

      -- Changed this CALL
      -- CALL App_Person_Type1_List(newid);
      -- to this:
      CALL App_Person_Type1_List(id_household, newid);
   END IF;
END  $$


-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Type1_Read $$
CREATE PROCEDURE App_Person_Type1_Read(id_household INT UNSIGNED,
                                       id INT UNSIGNED)
BEGIN
   SELECT p.id,
          p.fname,
          p.lname
     FROM Person p
    WHERE p.id_household = id_household
      AND (id IS NULL OR p.id = id);
END  $$


-- -----------------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Type1_Value $$
CREATE PROCEDURE App_Person_Type1_Value(id_household INT UNSIGNED,
                                        id INT UNSIGNED)
BEGIN
   SELECT p.id,
          p.fname,
          p.lname
          -- An option not used here is to include this line:
          -- p.id_household AS c_id_household.
          -- This example is using qstring variables instead.
     FROM Person p
    WHERE p.id_household = id_household
      AND p.id = id;
END $$


-- ------------------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Type1_Update $$
CREATE PROCEDURE App_Person_Type1_Update(id INT UNSIGNED,
                                         fname VARCHAR(20),
                                         lname VARCHAR(40),
                                         c_id_household INT UNSIGNED)
BEGIN
   UPDATE Person p
      SET p.fname = fname,
          p.lname = lname
    WHERE p.id = id
      AND p.id_household = c_id_household;

   IF ROW_COUNT() > 0 THEN
      -- Changed this CALL
      -- CALL App_Person_Type1_List(id);
      -- to this:
      CALL App_Person_Type1_List(c_id_household, id);
   END IF;
END $$



-- ------------------------------------------------
DROP PROCEDURE IF EXISTS App_Person_Type1_Delete $$
CREATE PROCEDURE App_Person_Type1_Delete(id_household INT UNSIGNED,
                                         id INT UNSIGNED)
BEGIN
   DELETE
     FROM p USING Person AS p
    WHERE p.id_household = id_household
      AND p.id = id;

   SELECT ROW_COUNT() AS deleted;
END  $$

DELIMITER ;
