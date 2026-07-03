class EncountersController < ApplicationController
  def new
    @trainer = current_trainer
    @wild_pokemon = RandomPokemon.retrieve
  end
end
