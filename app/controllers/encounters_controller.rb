class EncountersController < ApplicationController
  def new
    @trainer = current_trainer
    highest_level_pokemon = @trainer.pokemons.highest_level
    @wild_pokemon = RandomPokemon.retrieve(highest_level_pokemon)
  end
end
