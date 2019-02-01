DELIMITER $$
DROP PROCEDURE IF EXISTS App_Person_isoTable_Create_Temp_Table $$
CREATE PROCEDURE App_Person_isoTable_Create_Temp_Table()
BEGIN
   DROP TABLE IF EXISTS Buffer_Table_Person;
   CREATE TEMPORARY TABLE IF NOT EXISTS Buffer_Table_Person
   (
      id    INT(10) UNSIGNED NULL,
      fname VARCHAR(20) NULL,
      lname VARCHAR(40) NULL
   );
END $$

DROP PROCEDURE IF EXISTS App_Person_isoTable_Fill_Temp_Table $$
CREATE PROCEDURE App_Person_isoTable_Fill_Temp_Table(tabletext TEXT)
BEGIN
   DECLARE TOK_LINE   CHAR(1);
   DECLARE TOK_FIELD  CHAR(1);
   DECLARE REM_LINES  TEXT;
   DECLARE REM_FIELDS TEXT;
   DECLARE CUR_FIELD  TEXT;
   DECLARE NDX_FIELD  INT UNSIGNED;

   DECLARE id    INT(10) UNSIGNED;
   DECLARE fname VARCHAR(20);
   DECLARE lname VARCHAR(40);

   SELECT ';', '|' INTO TOK_LINE, TOK_FIELD;
   SET REM_LINES = tabletext;
   WHILE LENGTH(REM_LINES) > 0 DO
      SET REM_FIELDS = SUBSTRING_INDEX(REM_LINES, TOK_LINE, 1);
      SET REM_LINES = SUBSTRING(REM_LINES, LENGTH(REM_FIELDS)+2);
      SET NDX_FIELD = 0;

      SET id    = NULL;
      SET fname = NULL;
      SET lname = NULL;

      WHILE LENGTH(REM_FIELDS) > 0 DO
         SET CUR_FIELD = SUBSTRING_INDEX(REM_FIELDS, TOK_FIELD, 1);
         SET REM_FIELDS = SUBSTRING(REM_FIELDS, LENGTH(CUR_FIELD)+2);
         CASE NDX_FIELD
            WHEN 0 THEN SET id = NULLIF(CUR_FIELD,'');
            WHEN 1 THEN SET fname = NULLIF(CUR_FIELD,'');
            WHEN 2 THEN SET lname = NULLIF(CUR_FIELD,'');
         END CASE;
         SET NDX_FIELD = NDX_FIELD + 1;
      END WHILE;

      INSERT INTO Buffer_Table_Person
         (id, fname, lname)
      VALUES
         (id, fname, lname);
      
   END WHILE;
END $$

DELIMITER ;
