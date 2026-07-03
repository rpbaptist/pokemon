require "rails_helper"

RSpec.describe RandomPokemon do
  describe ".retrieve" do
    before { BasePokemon.create!(name: "Rattata", slug: "rattata") }

    it "creates a pokemon at level between 1 and 4 when no pokemon is given" do
      result = RandomPokemon.retrieve

      expect(result.level).to be_between(1, 4)
    end

    it "creates a pokemon within 3 levels of the given pokemon" do
      base_pokemon = BasePokemon.create!(name: "Pikachu", slug: "pikachu")
      trainers_pokemon = Pokemon.create!(base_pokemon: base_pokemon, level: 10)

      result = RandomPokemon.retrieve(trainers_pokemon)

      expect(result.level).to be_between(7, 13)
    end

    it "clamps the level floor to 1 for low-level pokemons" do
      base_pokemon = BasePokemon.create!(name: "Pikachu", slug: "pikachu")
      trainers_pokemon = Pokemon.create!(base_pokemon: base_pokemon, level: 2)

      result = RandomPokemon.retrieve(trainers_pokemon)

      expect(result.level).to be_between(1, 5)
    end

    it "returns nil when there are no base pokemons" do
      BasePokemon.delete_all

      expect(RandomPokemon.retrieve).to be_nil
    end

    it "keeps the other stats hardcoded to 1" do
      result = RandomPokemon.retrieve

      expect(result.hp).to eq(1)
      expect(result.attack).to eq(1)
    end
  end
end
