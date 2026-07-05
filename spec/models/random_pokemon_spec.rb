require "rails_helper"

RSpec.describe RandomPokemon do
  describe ".retrieve" do
    let(:base_stats) do
      {hp: 35, attack: 55, special_attack: 50, defense: 40, special_defense: 50, speed: 90}
    end

    before { BasePokemon.create!(name: "Rattata", slug: "rattata", **base_stats) }

    it "creates a pokemon at level between 1 and 4 when no pokemon is given" do
      result = RandomPokemon.retrieve

      expect(result.level).to be_between(1, 4)
    end

    it "creates a pokemon within 3 levels of the given pokemon" do
      base_pokemon = BasePokemon.create!(name: "Pikachu", slug: "pikachu", **base_stats)
      trainers_pokemon = Pokemon.create!(base_pokemon: base_pokemon, level: 10)

      result = RandomPokemon.retrieve(trainers_pokemon)

      expect(result.level).to be_between(7, 13)
    end

    it "clamps the level floor to 1 for low-level pokemons" do
      base_pokemon = BasePokemon.create!(name: "Pikachu", slug: "pikachu", **base_stats)
      trainers_pokemon = Pokemon.create!(base_pokemon: base_pokemon, level: 2)

      result = RandomPokemon.retrieve(trainers_pokemon)

      expect(result.level).to be_between(1, 5)
    end

    it "returns nil when there are no base pokemons" do
      BasePokemon.delete_all

      expect(RandomPokemon.retrieve).to be_nil
    end

    it "derives stats from the base pokemon's stats at the given level" do
      base_pokemon = BasePokemon.create!(name: "Pikachu", slug: "pikachu", **base_stats)
      trainers_pokemon = Pokemon.create!(base_pokemon: base_pokemon, level: 10)

      result = RandomPokemon.retrieve(trainers_pokemon)

      expect(result.hp).to eq(result.base_pokemon.stat_at_level(:hp, result.level))
      expect(result.attack).to eq(result.base_pokemon.stat_at_level(:attack, result.level))
      expect(result.current_hp).to eq(result.hp)
      expect(result.current_attack).to eq(result.attack)
    end
  end
end
