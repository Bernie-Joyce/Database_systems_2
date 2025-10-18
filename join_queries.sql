-- Select all pokemon, and their types
SELECT p.name, t.type_name
FROM Pokemon AS p
LEFT JOIN PokemonTypes AS pt ON p.pokemon_id = pt.pokemon_id
LEFT JOIN Types AS t ON t.type_id = pt.type_id
WHERE t.type_name = 'Normal';

