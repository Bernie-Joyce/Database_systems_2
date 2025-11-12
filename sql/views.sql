-- View that calculates stats for each caught pokemon based on their base stats and IVs
-- Reason: If players want to quickly check what statistics their caught Pokémon have it’s crucial to have a view that calculates those and lets them quickly see what random statistics their caught Pokémon possess
CREATE VIEW TrainerPokemonStats AS
SELECT tp.caught_id, tp.trainer_id, tp.nick_name AS Name, p.name AS Species, tp.pokemon_level as Level,

-- Calculated HP
FLOOR(
    (
        (p.base_hp + tp.hit_points_iv) * 2 * tp.pokemon_level
    ) / 100
) + tp.pokemon_level + 10 AS HP,

-- Calculated Attack
FLOOR(
    (
        (p.base_attack + tp.attack_iv) * 2 * tp.pokemon_level
    ) / 100
) + 5 AS Attack,

-- Calculated Defense
FLOOR(
    (
        (
            p.base_defense + tp.defense_iv
        ) * 2 * tp.pokemon_level
    ) / 100
) + 5 AS Defense
FROM TrainerPokemon tp
    JOIN Pokemon p ON tp.pokemon_id = p.pokemon_id;

-- View: Displays each Pokemon with all of its types combined into one line
-- Reason: To simplify data analysis by displaying each Pokémon and all of its types on a single line instead of multiple rows.
CREATE VIEW PokemonWithTypes AS
SELECT p.pokemon_id, p.name, GROUP_CONCAT(
        t.type_name
        ORDER BY t.type_name SEPARATOR '/'
    ) AS types
FROM
    Pokemon AS p
    LEFT JOIN PokemonTypes AS pt ON pt.pokemon_id = p.pokemon_id
    LEFT JOIN Types AS t ON t.type_id = pt.type_id
GROUP BY
    p.pokemon_id,
    p.name;

-- View: Displays trainer details with total pokemon, if there a gym leader and there location
-- Reason: Table view to see all the details of a trainer
CREATE VIEW TrainerSummary AS
SELECT
    tr.trainer_id,
    tr.name AS TrainerName,
    tr.gender,
    tr.age,
    COUNT(tp.pokemon_id) AS TotalPokemon,
    CASE
        WHEN g.leader_id IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS IsGymLeader,
    twn.name AS HomeTown,
    r.name AS Region,
    gt.name AS GymTown,
    ty.type_name AS GymType
FROM
    Trainer AS tr
    LEFT JOIN TrainerPokemon AS tp ON tr.trainer_id = tp.trainer_id
    LEFT JOIN Gym AS g ON tr.trainer_id = g.leader_id
    LEFT JOIN Town AS gt ON g.town_id = gt.town_id
    LEFT JOIN Types AS ty ON g.type_id = ty.type_id
    JOIN Town AS twn ON tr.home_town_id = twn.town_id
    JOIN Region AS r ON twn.region_id = r.region_id
GROUP BY
    tr.trainer_id,
    tr.name,
    tr.gender,
    tr.age,
    g.leader_id,
    twn.name,
    r.name,
    gt.name,
    ty.type_name;

--Shows each trainer's highest level pokemon
--Reason: Allows quick access to see which pokemon is the strongest in each trainer's collection
CREATE VIEW TrainerPokemonMaxLevelView AS
SELECT
    t.trainer_id,
    t.name AS trainer_name,
    p.name AS pokemon_name,
    tp.pokemon_level AS pokemons_level
FROM
    Trainer t
    JOIN TrainerPokemon tp ON t.trainer_id = tp.trainer_id
    JOIN Pokemon p ON tp.pokemon_id = p.pokemon_id
WHERE
    tp.pokemon_level = (
        SELECT MAX(p2.pokemon_level)
        FROM TrainerPokemon p2
        WHERE
            p2.trainer_id = t.trainer_id
    );