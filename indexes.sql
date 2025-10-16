-- Index for the region join
CREATE INDEX index_wildpokemon_region ON wildpokemon(region_id);
-- Index for the pokemon join
CREATE INDEX index_wildpokemon_pokemon ON wildpokemon(pokemon_id);
-- To show indexes being used run
EXPLAIN
SELECT 
    p.name AS pokemon_name,
    r.name AS region,
    w.location_description,
    w.min_level,
    w.max_level
FROM wildpokemon AS w
JOIN region AS r ON w.region_id = r.region_id
JOIN pokemon AS p ON w.pokemon_id = p.pokemon_id;
