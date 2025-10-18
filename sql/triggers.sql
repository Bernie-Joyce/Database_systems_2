-- Log deleted trainer after delete
DELIMITER $$

CREATE TRIGGER after_trainer_delete
AFTER DELETE ON Trainer
FOR EACH ROW
BEGIN
  INSERT INTO DeletedTrainers (TrainerID, Name, Action)
  VALUES (OLD.trainer_id, OLD.name, 'deleted');

END$$
DELIMITER ;


-- Delete trainer pokemon before trainer
DELIMITER $$

CREATE TRIGGER delete_trainer_pokemon
BEFORE DELETE ON Trainer
FOR EACH ROW
BEGIN
  DELETE FROM TrainerPokemon
  WHERE trainer_id = OLD.trainer_id;

END $$
DELIMITER ;


-- Change gym leader if curent leader gets deleted
DELIMITER $$

CREATE TRIGGER change_leader_if_deleted
BEFORE DELETE ON Trainer
FOR EACH ROW
BEGIN
    DECLARE new_leader INT;

    -- If the deleted player is NOT trainer 4:
    IF OLD.trainer_id <> 4 THEN
        -- Reassign their gyms to trainer 4
        UPDATE Gym
        SET leader_id = 4
        WHERE leader_id = OLD.trainer_id;

    ELSE
        SELECT trainer_id
        INTO new_leader
        FROM Trainer
        WHERE trainer_id <> OLD.trainer_id
        ORDER BY trainer_id
        LIMIT 1;

        IF new_leader IS NOT NULL THEN
            UPDATE Gym
            SET leader_id = new_leader
            WHERE leader_id = OLD.trainer_id;
        END IF;
    END IF;

END $$
DELIMITER ;


-- Automatically adjust pokemon level to stay within valid bounds (between 1 and 100)
DELIMITER $$

CREATE TRIGGER check_pokemon_level
BEFORE INSERT ON TrainerPokemon
FOR EACH ROW
BEGIN
  -- If level less than 1, set it to 1
  IF NEW.pokemon_level < 1 THEN
    SET NEW.pokemon_level = 1;
  END IF;

  -- If level greater than 100, set it to 100
  IF NEW.pokemon_level > 100 THEN
    SET NEW.pokemon_level = 100;
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_insert_trainer
AFTER INSERT ON Trainer
FOR EACH ROW
BEGIN
    DECLARE rand_int INT;
    DECLARE starter_id INT;

    SET rand_int = FLOOR(RAND() * 3);

    CASE rand_int
        WHEN 0 THEN SET starter_id = 1; -- Bulbasaur
        WHEN 1 THEN SET starter_id = 4; -- Charmander
        WHEN 2 THEN SET starter_id = 7; -- Squirtle
    END CASE;

    INSERT INTO TrainerPokemon (
        trainer_id, pokemon_id, nick_name, pokemon_level,
        hit_points_iv, attack_iv, defense_iv
    )
    VALUES (
        NEW.trainer_id, starter_id, 'Starter', 5,
        FLOOR(RAND() * 32), FLOOR(RAND() * 32), FLOOR(RAND() * 32)
    );
END$$

DELIMITER ;

