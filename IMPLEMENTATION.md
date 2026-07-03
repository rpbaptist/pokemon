# Implementation details

## Acceptance criteria 1

### 1.a

- [x] Default trainer present as `current_trainer`
- [x] Use `current_trainer.pokemons.highest_level`.
- [x] Pokemon in encounter may not be more than 3 levels higher or lower than `highest_level_pokemon`
   `RandomPokemon.retrieve` should take argument `pokemon` and compare levels before retrieving. If no argument is
given, it should show a random pokemon of level 1-4 (i.e. treated as base level 1, clamped ±3). 

### 1.b

- [x] Add `BasePokemon#stat_at_level(stat_name, level)`, using the official formula with IV/EV/Nature treated as neutral 
   - `hp`: `floor(2 * base * level / 100) + level + 10`
   - all other stats: `floor(2 * base * level / 100) + 5`
- [x] In `RandomPokemon.retrieve`, replace the hardcoded `1`s with `sample_base_pokemon.stat_at_level(stat, level)` for each of `hp`, `attack`, `special_attack`, `defense`, `special_defense`, `speed`
- [x] `current_*` stats are set equal to the freshly calculated stat (full health/full stats on spawn, same precedent as `db/seeds.rb`'s Pikachu)
- [x] Update `spec/models/random_pokemon_spec.rb` to give `BasePokemon` fixtures real base stats instead of relying on `nil` columns

## Acceptance criteria 2

- [x] Implemented via `Battles.EscapeAttempt`

## Acceptance criteria 3

- [ ] Add a `capture` action in a fight with 50% success rate. Should follow the pattern of `Battles.EscapeAttempt`
- [ ] If `capture` succeeds, `Battle.state` is recorded as `captured`
- [ ] If `capture` fails, pokemon has 30% chance to escape. `Battle.state` is recoded as `escaped`.

## Acceptance criteria 4

- [ ] When starting a battle, `trainer.pokemon.first` starts the battle.
- [ ] Starting move is determined by fastest pokemon: `speed`. When equal, randomize, 50% coin flip.
- [ ] Each round, the trainer pokemon and the wild pokemon may perform one action: `fight`, `escape`. Trainer pokemon
may use `capture` as well.
- [ ] When one of the Pokemon's HP is 0, the battle ends with either `victory` or `defeat`


