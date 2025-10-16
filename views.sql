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
    
FROM trainerpokemon tp
JOIN pokemon p ON tp.pokemon_id = p.pokemon_id;
