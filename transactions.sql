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
    UPDATE TrainerPokemon
    SET trainer_id = t2_id
    WHERE caught_id = p1_id AND trainer_id = t1_id;
    SET rows1 = ROW_COUNT();

    --  Transfer Pokemon 2 to trainer 1 and set amount of rows affected
    UPDATE TrainerPokemon
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



-- A stored procedure used to simulate buying a wild pokemon by a trainer
-- Rolls back if any insert/update fails
-- Example test:
-- CALL BuyPokemon(1, 1, 5, 25, 12, 10, 10, 10);

DELIMITER $$

CREATE PROCEDURE BuyPokemon(
    IN wild_pokemon_id INT,  -- ID in WildPokemon
    IN trainer_id INT,       -- trainer who buys
    IN pokemon_level INT,
    IN hit_iv INT,
    IN atk_iv INT,
    IN def_iv INT
)
BEGIN
    DECLARE pkmn_id INT;
    DECLARE pkmn_name VARCHAR(50);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Purchase failed, rolled back' AS status;
    END;

    START TRANSACTION;

    -- Get pokemon ID and name from WildPokemon
    SELECT wp.pokemon_id, p.name
    INTO pkmn_id, pkmn_name
    FROM WildPokemon AS wp
    JOIN Pokemon AS p ON wp.pokemon_id = p.pokemon_id
    WHERE wp.wild_id = wild_pokemon_id;

    -- Insert into TrainerPokemon table (trainer now owns it)
    INSERT INTO TrainerPokemon(trainer_id, pokemon_id, nick_name, pokemon_level, hit_points_iv, attack_iv, defense_iv)
    VALUES (trainer_id, pkmn_id, pkmn_name, pokemon_level, hit_iv, atk_iv, def_iv);

    -- Remove from WildPokemon (caught)
    DELETE FROM WildPokemon WHERE wild_id = wild_pokemon_id;

    COMMIT;
    SELECT CONCAT('Trainer ', trainer_id, ' successfully bought ', pkmn_name) AS status;
END$$

DELIMITER ;
