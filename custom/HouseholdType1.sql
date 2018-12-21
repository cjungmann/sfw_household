USE SFW_Households;
DELIMITER $$

-- -------------------------------------------------
DROP PROCEDURE IF EXISTS App_Household_Type1_List $$
CREATE PROCEDURE App_Household_Type1_List(id INT UNSIGNED)
BEGIN
   SELECT h.id,
          h.name
     FROM Household h
    WHERE (id IS NULL OR h.id = id);
END  $$


-- ------------------------------------------------
DROP PROCEDURE IF EXISTS App_Household_Type1_Add $$
CREATE PROCEDURE App_Household_Type1_Add(name VARCHAR(40))
BEGIN
   DECLARE newid INT UNSIGNED;
   DECLARE rcount INT UNSIGNED;

   INSERT INTO Household
          (name)
   VALUES (name);

   SELECT ROW_COUNT() INTO rcount;
   IF rcount > 0 THEN
      SET newid = LAST_INSERT_ID();
      CALL App_Household_Type1_List(newid);
   END IF;
END  $$


-- -------------------------------------------------
DROP PROCEDURE IF EXISTS App_Household_Type1_Read $$
CREATE PROCEDURE App_Household_Type1_Read(id INT UNSIGNED)
BEGIN
   SELECT h.id,
          h.name
     FROM Household h
    WHERE (id IS NULL OR h.id = id);
END  $$


-- --------------------------------------------------
DROP PROCEDURE IF EXISTS App_Household_Type1_Value $$
CREATE PROCEDURE App_Household_Type1_Value(id INT UNSIGNED)
BEGIN
   SELECT h.id,
          h.name
     FROM Household h
    WHERE h.id = id;
END $$


-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS App_Household_Type1_Update $$
CREATE PROCEDURE App_Household_Type1_Update(id INT UNSIGNED,
                                            name VARCHAR(40))
BEGIN
   UPDATE Household h
      SET h.name = name
    WHERE h.id = id;

   IF ROW_COUNT() > 0 THEN
      CALL App_Household_Type1_List(id);
   END IF;
END $$



-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS App_Household_Type1_Delete $$
CREATE PROCEDURE App_Household_Type1_Delete(id INT UNSIGNED)
BEGIN
   DELETE
     FROM h USING Household AS h
    WHERE h.id = id;

   SELECT ROW_COUNT() AS deleted;
END  $$

DELIMITER ;
