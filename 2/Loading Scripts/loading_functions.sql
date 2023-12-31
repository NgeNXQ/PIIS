USE movies;

DROP FUNCTION IF EXISTS FORMAT_TITLE;
DROP FUNCTION IF EXISTS CONVERT_STRING_TIME;
DROP FUNCTION IF EXISTS TRANSFORM_DIRECTOR_REVERSED;
DROP FUNCTION IF EXISTS TRANSFROM_DIRECTOR_PASCAL_CASE;
DROP FUNCTION IF EXISTS CUT_GENRE;

DELIMITER $$
CREATE FUNCTION FORMAT_TITLE(input VARCHAR(100)) RETURNS VARCHAR(100) NO SQL NOT DETERMINISTIC
BEGIN
	IF (input LIKE '%, The') THEN
		SET input = CONCAT('The ', SUBSTRING_INDEX(input, ', The', 1));
    END IF;
    
    RETURN input;
END $$

DELIMITER $$
CREATE FUNCTION TRANSFORM_DIRECTOR_REVERSED(input VARCHAR(100)) RETURNS VARCHAR(100) NO SQL NOT DETERMINISTIC
BEGIN
    DECLARE separator_index INT;
    DECLARE first_name VARCHAR(100);
    DECLARE last_name VARCHAR(100);

    SET separator_index = LOCATE(',', input);
    SET last_name = TRIM(SUBSTRING(input, 1, separator_index - 1));
    SET first_name = TRIM(SUBSTRING(input, separator_index + 1));

    RETURN CONCAT(first_name, ' ', last_name);
END $$

DELIMITER $$
CREATE FUNCTION TRANSFROM_DIRECTOR_PASCAL_CASE(input VARCHAR(100)) RETURNS VARCHAR(100) NO SQL NOT DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE result VARCHAR(100) DEFAULT '';
    DECLARE len INT DEFAULT LENGTH(input);

    WHILE (i <= len) DO
        IF (ASCII(SUBSTRING(input, i, 1)) BETWEEN 65 AND 90) THEN
            SET result = CONCAT(result, ' ', SUBSTRING(input, i, 1));
        ELSE
            SET result = CONCAT(result, SUBSTRING(input, i, 1));
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN TRIM(result);
END $$

DELIMITER $$
CREATE FUNCTION CONVERT_STRING_TIME(input VARCHAR(12)) RETURNS INT NO SQL NOT DETERMINISTIC
BEGIN
	RETURN CAST(SUBSTRING_INDEX(input, ' hr ', 1) AS UNSIGNED) * 60 + CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(input, ' hr ', -1), ' min', 1) AS UNSIGNED);
END $$

DELIMITER $$
CREATE FUNCTION CUT_GENRE(input VARCHAR(50)) RETURNS VARCHAR(50) NO SQL NOT DETERMINISTIC
BEGIN
	RETURN SUBSTRING_INDEX(input, ',', 1);
END $$