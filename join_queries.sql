-- Select all pokemon, and their types
SELECT p.name, t.type_name
FROM pokemon AS p
LEFT JOIN pokemontypes AS pt ON p.pokemon_id = pt.pokemon_id
LEFT JOIN types AS t ON t.type_id = pt.type_id
WHERE t.type_name = 'Normal';
