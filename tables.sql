CREATE TABLE Region(
    region_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    climate VARCHAR(50) NOT NULL
);CREATE TABLE Town(
    town_id INT PRIMARY KEY,
    region_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    population INT NOT NULL,
    FOREIGN KEY(region_id) REFERENCES Region(region_id)
);CREATE TABLE Types(
    type_id INT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL
);CREATE TABLE Trainer(
    trainer_id INT PRIMARY KEY,
    home_town_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    age INT,
    FOREIGN KEY(home_town_id) REFERENCES Town(town_id)
); CREATE TABLE Pokemon(
    pokemon_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    base_hp INT NOT NULL,
    base_attack INT NOT NULL,
    base_defense INT NOT NULL
);  CREATE TABLE PokemonTypes(
    pokemon_id INT NOT NULL,
    type_id INT NOT NULL,
    FOREIGN KEY(pokemon_id) REFERENCES Pokemon(pokemon_id),
    FOREIGN KEY(type_id) REFERENCES type(type_id)
);  CREATE TABLE TrainerPokemon(
    caught_id INT PRIMARY KEY,
    trainer_id INT NOT NULL,
    pokemon_id INT NOT NULL,
    nick_name VARCHAR(50) NOT NULL,
    pokemon_level INT NOT NULL,
    hit_points INT NOT NULL,
    attack INT NOT NULL,
    defense INT NOT NULL,
    FOREIGN KEY(trainer_id) REFERENCES Trainer(trainer_id),
    FOREIGN KEY(pokemon_id) REFERENCES Pokemon(pokemon_id)
); CREATE TABLE Gym(
    gym_id INT PRIMARY KEY,
    leader_id INT NOT NULL,
    town_id INT NOT NULL,
    type_id INT NOT NULL,
    badge VARCHAR(50) NOT NULL,
    FOREIGN KEY(leader_id) REFERENCES Trainer(trainer_id),
    FOREIGN KEY(town_id) REFERENCES Town(town_id),
    FOREIGN KEY(type_id) REFERENCES TYPE(type_id)
);  CREATE TABLE TypeAdvantage(
    type_1 INT NOT NULL,
    type_2 INT NOT NULL,
    type_advantage VARCHAR(50) NOT NULL,
    FOREIGN KEY(type_1) REFERENCES TYPE(type_id),
    FOREIGN KEY(type_2) REFERENCES TYPE(type_id)
); CREATE TABLE WildPokemon(
    wild_id INT PRIMARY KEY,
    pokemon_id INT NOT NULL,
    region_id INT NOT NULL,
    location_description VARCHAR(50) NOT NULL,
    min_level INT NOT NULL,
    max_level INT NOT NULL,
    FOREIGN KEY(pokemon_id) REFERENCES Pokemon(pokemon_id),
    FOREIGN KEY(region_id) REFERENCES Region(region_id)
);
