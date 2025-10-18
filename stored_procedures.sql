-- Procedure used to add a new pokemon
DELIMITER $$

CREATE PROCEDURE AddPokemon(IN species_name VARCHAR(50), IN baseHP INT, IN baseAttack INT, IN baseDefense INT, IN type1ID INT, IN type2ID INT, IN regionID INT, IN locationDescription VARCHAR(50), IN minLevel INT, IN maxLevel INT)
BEGIN
	-- Declare a variable to store new pokemon ID
	DECLARE new_pokemon_id INT;
	
	INSERT INTO Pokemon(name, base_hp, base_attack, base_defense)
	VALUES (species_name, baseHP, baseAttack, baseDefense);

	-- Set last inserted ID as new pokemon ID 
	SET new_pokemon_id = LAST_INSERT_ID();

	-- Insert data into wildpokemon using new ID  
	INSERT INTO WildPokemon(pokemon_id, region_id, location_description, min_level, max_level)
	VALUES (new_pokemon_id, regionID, locationDescription, minLevel, maxLevel);

	-- Insert first type
	INSERT INTO PokemonTypes(pokemon_id, type_id)
	VALUES (new_pokemon_id, type1ID);

	-- Insert second type if exists
	IF type2ID IS NOT NULL THEN
		 INSERT INTO PokemonTypes(pokemon_id, type_id)
        VALUES (new_pokemon_id, type2ID);
    END IF;
END$$

DELIMITER ;
