-- Log deleted trainer after delete
-- Keep record of all removed trainers In case the game needs to be restarted
DELIMITER $$

CREATE TRIGGER after_trainer_delete
AFTER DELETE ON Trainer
FOR EACH ROW
BEGIN
  INSERT INTO DeletedTrainers (TrainerID, Name, Action)
  VALUES (OLD.trainer_id, OLD.name, 'deleted');

END$$

DELIMITER;

-- Delete trainer pokemon before trainer
-- Reason: Due to trainer Pokémon relying on Trainer, the trainer can’t be removed. Removing their Pokémon first is necessary.
DELIMITER $$

CREATE TRIGGER delete_trainer_pokemon
BEFORE DELETE ON Trainer
FOR EACH ROW
BEGIN
  DELETE FROM TrainerPokemon
  WHERE trainer_id = OLD.trainer_id;

END $$

DELIMITER;

-- Change gym leader if the current leader gets deleted
-- Reason: Due to trainer gym relying on Trainer as its leader, the trainer can’t be removed directly. If deleted trainer was a gym leader, gym leader has to be change first.
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
    
    -- Else select the next available trainer
    ELSE
        SELECT trainer_id
        INTO new_leader
        FROM Trainer
        WHERE trainer_id <> OLD.trainer_id
        ORDER BY trainer_id
        LIMIT 1;

        -- Update gym leader to the next available leader
        IF new_leader IS NOT NULL THEN
            UPDATE Gym
            SET leader_id = new_leader
            WHERE leader_id = OLD.trainer_id;
        END IF;
    END IF;

END $$

DELIMITER;

-- Automatically adjust pokemon level to stay within valid bounds (between 1 and 100)
-- Reason: To ensure all Pokémon levels inserted into the TrainerPokemon table remain within valid gameplay limits (1–100).
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

DELIMITER;

-- Cap caught pokemon max IVs
-- Reason: Make sure no pokemons stats were higher than they should be
DELIMITER $$

create trigger cap_max_iv
    before insert on TrainerPokemon
    for each row
    begin
        -- Check if each IV is lower than 31 and change it to 31 otherwise
        if NEW.hit_points_iv > 31 then
            set new.hit_points_iv = 31;
        end if;
        if NEW.attack_iv > 31 then
            set new.attack_iv = 31;
        end if;
        if NEW.defense_iv > 31 then
            set new.defense_iv = 31;
        end if;
    end;

DELIMITER;

--Caps trainer to 6 pokemon max
--Reason: Ensures no trainer has more pokemon than they logically should

DELIMITER $$

CREATE TRIGGER cap_trainer_pokemon
BEFORE INSERT ON TrainerPokemon
FOR EACH ROW
BEGIN
DECLARE pokemon_count INT;
SELECT COUNT(*) INTO pokemon_count FROM TrainerPokemon WHERE trainer_id = NEW.trainer_id;
IF pokemon_count >=6 THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trainer already has 6 pokemon, they cannot have more in their party';
END IF;
END$$

DELIMITER;