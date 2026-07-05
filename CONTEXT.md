# Pokemon Assignment

Domain glossary for the Pokémon battle/capture game.

## Language

**Battle**:
An encounter between a Trainer's active Pokémon and an Opponent, tracked through a lifecycle of states (start, move_selection, escaped, fled, captured, victory, defeat).
_Avoid_: Fight

**Encounter**:
The moment a wild Pokémon is generated for the player to potentially Battle. Not a persisted resource — it's the transient wild Pokémon shown on `/encounters/new`, before a Battle exists.
_Avoid_: Battle

**Opponent**:
The wild Pokémon in a Battle — a Pokémon with no owning Trainer (`trainer_id: nil`). Same `Pokemon` model as owned Pokémon, just untrained.
_Avoid_: Wild Pokémon (as if it were a separate model)

**Escape attempt**:
A Trainer's single try at fleeing an ongoing Battle. Always processed successfully as a request; whether the Pokémon actually gets away is a 50% random outcome. Ends the Battle (state `escaped`) only if successful.
_Avoid_: Escape (ambiguous between the action and its successful outcome)

**Base stat**:
A species-level baseline value (`hp`, `attack`, `special_attack`, `defense`, `special_defense`, `speed`) stored on `BasePokemon`, imported from PokeAPI. Distinct from the same-named columns on `Pokemon`, which hold that individual's actual stat at its current level, derived from the Base stat via `BasePokemon#stat_at_level`.
_Avoid_: Stat (ambiguous between the species baseline and the individual's leveled value)
