-- Because of constraints Delete statements can only be run properly with triggers present

-- Update pokemon level by 1 for each pokemon with trainer_id = 4
UPDATE trainerpokemon AS tp
SET tp.pokemon_level = tp.pokemon_level + 1
WHERE tp.trainer_id = 4;

-- Delete all of trainer 6's pokemon
DELETE FROM trainerpokemon
WHERE trainer_id = 6
