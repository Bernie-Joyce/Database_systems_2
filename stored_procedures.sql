-- Procedure used to add a new pokemon
DELIMITER $$

CREATE PROCEDURE AddPokemon(IN species_name VARCHAR(50), IN baseHP INT, IN baseAttack INT, IN baseDefense INT, IN type1ID INT, IN type2ID INT, IN regionID INT, IN locationDescription VARCHAR(50), IN minLevel INT, IN maxLevel INT)
BEGIN
	DECLARE new_pokemon_id INT;
	INSERT INTO pokemon(name, base_hp, base_attack, base_defense)
	VALUES (species_name, baseHP, baseAttack, baseDefense);

	SET new_pokemon_id = LAST_INSERT_ID();

	INSERT INTO wildpokemon(pokemon_id, region_id, location_description, min_level, max_level)
	VALUES (new_pokemon_id, regionID, locationDescription, minLevel, maxLevel);

	INSERT INTO pokemontypes(pokemon_id, type_id)
	VALUES (new_pokemon_id, typeID);
	IF type2ID IS NOT NULL THEN
		 INSERT INTO pokemontypes(pokemon_id, type_id)
        VALUES (new_pokemon_id, typeID2);
    END IF;
END$$

DELIMITER 
