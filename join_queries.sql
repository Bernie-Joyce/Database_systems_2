-- Select all pokemon, and their types
SELECT p.name, t.type_name
FROM Pokemon AS p
LEFT JOIN PokemonTypes AS pt ON p.pokemon_id = pt.pokemon_id
LEFT JOIN Types AS t ON t.type_id = pt.type_id
WHERE t.type_name = 'Normal';

-- Show trainers and the Pokémon they own
SELECT
    tr.name AS Trainer,
    tr.gender,
    tr.age,
    p.name AS Pokemon,
    tp.nick_name AS Nickname,
    tp.pokemon_level AS Level
FROM TrainerPokemon AS tp
JOIN Trainer AS tr ON tp.trainer_id = tr.trainer_id
JOIN Pokemon AS p ON tp.pokemon_id = p.pokemon_id
ORDER BY tr.name;