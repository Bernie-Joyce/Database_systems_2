-- Index for the region join
CREATE INDEX index_wildpokemon_region ON WildPokemon(region_id);

-- Index for the pokemon join
CREATE INDEX index_wildpokemon_pokemon ON WildPokemon(pokemon_id);

-- To show indexes being used run
EXPLAIN
SELECT 
    p.name AS pokemon_name,
    r.name AS region,
    w.location_description,
    w.min_level,
    w.max_level
FROM WildPokemon AS w
JOIN Region AS r ON w.region_id = r.region_id
JOIN Pokemon AS p ON w.pokemon_id = p.pokemon_id;
