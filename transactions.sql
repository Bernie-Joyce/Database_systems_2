-- A stored procedures used to trade pokemon which has a transaction that rollsback if an error occurs and commits otherwise
-- Can be tested running:
-- CALL TradePokemon(1, 1, 8, 4); 
-- twice

DELIMITER $$

  -- Create procedure to trade pokemon 
CREATE PROCEDURE TradePokemon(
    IN p1_id INT,
    IN t1_id INT,
    IN p2_id INT,
    IN t2_id INT
)
BEGIN
  -- declare variables to check how many rows get effected
    DECLARE rows1 INT DEFAULT 0;
    DECLARE rows2 INT DEFAULT 0;

-- check if sqlexception occurs
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Trade failed, rolled back' AS status;
    END;

    START TRANSACTION;

    -- Transfer Pokemon 1 to trainer 2 and set amount of rows affected
    UPDATE trainerpokemon
    SET trainer_id = t2_id
    WHERE caught_id = p1_id AND trainer_id = t1_id;
    SET rows1 = ROW_COUNT();

    --  Transfer Pokemon 2 to trainer 1 and set amount of rows affected
    UPDATE trainerpokemon
    SET trainer_id = t1_id
    WHERE caught_id = p2_id AND trainer_id = t2_id;
    SET rows2 = ROW_COUNT();

    -- Check if both updates affected exactly 1 row and commit else rollback
    IF rows1 = 1 AND rows2 = 1 THEN
        COMMIT;
        SELECT 'Trade successful' AS status;
    ELSE
        ROLLBACK;
        SELECT 'Trade failed, rolled back' AS status;
    END IF;
END$$

DELIMITER ;

