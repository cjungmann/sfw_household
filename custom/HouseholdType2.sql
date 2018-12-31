USE SFW_Households;
DELIMITER $$


-- -----------------------------------------------------
-- For the 'add' response mode, the setup procedure
-- creates the 'members' result to store new members
-- as they are added and to provide the schema for the
-- isotable input.
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_Add_Setup $$
CREATE PROCEDURE App_HouseholdType2_Add_Setup()
BEGIN
   SELECT id, fname, lname
     FROM Person
    WHERE 1 = 0;
END $$

-- -------------------------------------------------------
-- Customization: additional procedure to collect a household's
-- members.
-- -------------------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_Get_Members $$
CREATE PROCEDURE App_HouseholdType2_Get_Members(id INT UNSIGNED)
BEGIN
   SELECT p.id, p.fname, p.lname
     FROM Person p
    WHERE p.id_household = id;
END $$

-- ----------------------------------------------------------
-- Customization: additional procedure for reconciling
-- submitted member list with the persistent member list.
-- ----------------------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_Update_Members $$
CREATE PROCEDURE App_HouseholdType2_Update_Members(id INT UNSIGNED,
                                                   members TEXT)
BEGIN
   CALL App_Person_isoTable_Create_Temp_Table();
   CALL App_Person_isoTable_Fill_Temp_Table(members);

   -- Remove members not in submitted members list,
   DELETE p
     FROM Person p LEFT JOIN Buffer_Table_Person b
          ON p.id = b.id
    WHERE p.id_household = id
      AND b.id IS NULL;

   -- update values of members that do exist,
   UPDATE Person p
          INNER JOIN Buffer_Table_Person b
          ON p.id = b.id
      SET p.fname = b.fname,
          p.lname = b.lname
    WHERE p.id_household = id;

    -- then, finally, add members without ID value (new members):
    INSERT INTO Person (id_household, fname, lname)
    SELECT id, b.fname, b.lname
      FROM Buffer_Table_Person b
     WHERE b.id IS NULL;

   DROP TABLE IF EXISTS Buffer_Table_Person;
END $$

-- ------------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_List $$
CREATE PROCEDURE App_HouseholdType2_List(id INT UNSIGNED)
BEGIN
   SELECT h.id,
          h.name
     FROM Household h
    WHERE (id IS NULL OR h.id = id);
END  $$

-- -----------------------------------------------
-- Customization: add 'members' parameter and call
-- to procedure App_HouseholdType2_Update_Members.
-- -----------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_Add $$
CREATE PROCEDURE App_HouseholdType2_Add(name VARCHAR(40),
                                        members TEXT)   -- new parameter
BEGIN
   DECLARE newid INT UNSIGNED;
   DECLARE rcount INT UNSIGNED;

   INSERT INTO Household
          (name)
   VALUES (name);

   SELECT ROW_COUNT() INTO rcount;
   IF rcount > 0 THEN
      SET newid = LAST_INSERT_ID();
      CALL App_HouseholdType2_List(newid);

      -- new call:
      IF LENGTH(members) > 0 THEN
         CALL App_HouseholdType2_Update_Members(newid,members);
      END IF;
   END IF;
END  $$


-- ------------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_Read $$
CREATE PROCEDURE App_HouseholdType2_Read(id INT UNSIGNED)
BEGIN
   SELECT h.id,
          h.name
     FROM Household h
    WHERE (id IS NULL OR h.id = id);

    -- new call:
    CALL App_HouseholdType2_Get_Members(id);
END  $$


-- -------------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_Value $$
CREATE PROCEDURE App_HouseholdType2_Value(id INT UNSIGNED)
BEGIN
   SELECT h.id,
          h.name
     FROM Household h
    WHERE h.id = id;

    -- new call:
    CALL App_HouseholdType2_Get_Members(id);
END $$


-- --------------------------------------------------
-- Customization: additional parameter and call to
-- updating procedure
-- --------------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_Update $$
CREATE PROCEDURE App_HouseholdType2_Update(id INT UNSIGNED,
                                           name VARCHAR(40),
                                           members TEXT)    -- new param
BEGIN
   UPDATE Household h
      SET h.name = name
    WHERE h.id = id;

   -- new call.  Call first so _List accesses changed info:
   CALL App_HouseholdType2_Update_Members(id,members);

   CALL App_HouseholdType2_List(id);
END $$



-- --------------------------------------------------
DROP PROCEDURE IF EXISTS App_HouseholdType2_Delete $$
CREATE PROCEDURE App_HouseholdType2_Delete(id INT UNSIGNED)
BEGIN
   DELETE
     FROM h USING Household AS h
    WHERE h.id = id;

    -- Foreign key declaration should force deletion
    -- of household members.  Confirm this before removing
    -- this comment.

   SELECT ROW_COUNT() AS deleted;
END  $$

DELIMITER ;
