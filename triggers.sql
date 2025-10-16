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
  DELETE FROM trainerpokemon
  WHERE trainer_id = OLD.trainer_id;
END $$

-- change gym leader if curent leader gets deleted
  
DELIMITER ;
CREATE TRIGGER change_leader_if_deleted
BEFORE DELETE ON trainer
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
        FROM Player
        WHERE trainer_id <> OLD.trainer_id
        ORDER BY trainer_id
        LIMIT 1;

        IF new_leader IS NOT NULL THEN
            UPDATE Gym
            SET leader_id = new_leader
            WHERE leader_id = OLD.trainer_id;
        END IF;
    END IF;
END$$
