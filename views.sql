-- View that calculates stats for each caught pokemon based on their base stats and IVs
CREATE VIEW TrainerPokemonStats AS
SELECT
    tp.caught_id,
    tp.trainer_id,
    tp.nick_name AS Name,
    p.name AS Species,
    tp.pokemon_level as Level,
    
    -- Calculated HP
    FLOOR(((p.base_hp + tp.hit_points_iv) * 2 * tp.pokemon_level) / 100) + tp.pokemon_level + 10 AS HP,
    
    -- Calculated Attack
    FLOOR(((p.base_attack + tp.attack_iv) * 2 * tp.pokemon_level) / 100) + 5 AS Attack,
    
    -- Calculated Defense
    FLOOR(((p.base_defense + tp.defense_iv) * 2 * tp.pokemon_level) / 100) + 5 AS Defense
    
FROM TrainerPokemon tp
JOIN Pokemon p ON tp.pokemon_id = p.pokemon_id;

-- View: Displays each Pokemon with all of its types combined into one line
CREATE VIEW PokemonWithTypes AS
SELECT
  p.pokemon_id,
  p.name,
  GROUP_CONCAT(t.type_name ORDER BY t.type_name SEPARATOR '/') AS types
FROM Pokemon AS p
LEFT JOIN PokemonTypes AS pt ON pt.pokemon_id = p.pokemon_id
LEFT JOIN Types AS t         ON t.type_id = pt.type_id
GROUP BY p.pokemon_id, p.name;
