-- Reason: As players would frequently want to check where they can catch a specific Pokémon they want in their collection it’s beneficial for those queries to be run quickly. Having these indexes improves both speed at which the data is returned as well as efficiency when the dataset grows.
-- Index for the region join
CREATE INDEX index_wildpokemon_region ON WildPokemon (region_id);
-- Index for the pokemon join
CREATE INDEX index_wildpokemon_pokemon ON WildPokemon (pokemon_id);

-- Reason: To improve join performance between Pokémon and Types tables and demonstrate index usage through an updated EXPLAIN query.
-- Index for PokemonTypes join (frequent joins between Pokemon and Types)
CREATE INDEX idx_pokemontypes_pokemon_id ON PokemonTypes (pokemon_id);

CREATE INDEX idx_pokemontypes_type_id ON PokemonTypes (type_id);

--Reason: To improve query performance when filtering trainers by their home town.
CREATE INDEX index_trainer_home_town ON Trainer (home_town_id);

--Shows the idx_trainer_region index being used
EXPLAIN SELECT * FROM Trainer WHERE home_town_id = 1;

-- To show indexes between Wildpokemon, region and pokemon being used run
EXPLAIN
SELECT p.name AS pokemon_name, r.name AS region, w.location_description, w.min_level, w.max_level
FROM
    WildPokemon AS w
    JOIN Region AS r ON w.region_id = r.region_id
    JOIN Pokemon AS p ON w.pokemon_id = p.pokemon_id;