# Implementation details

## Acceptance criteria 1

### 1.a

- [x] Default trainer present as `current_trainer`
- [x] Use `current_trainer.pokemons.highest_level`.
- [x] Pokemon in encounter may not be more than 3 levels higher or lower than `highest_level_pokemon`
   `RandomPokemon.retrieve` should take argument `pokemon` and compare levels before retrieving. If no argument is
given, it should show a random pokemon of level 1-4 (i.e. treated as base level 1, clamped ±3). 

### 1.b

- [ ] When creating the pokemon from `base_pokemon` in `RandomPokemon` the stats need to be leveled up accordingly.

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


