require "rails_helper"

module Import
  RSpec.describe BasePokemonImporter do
    describe ".run" do
      let(:response) do
        JSON.parse(file_fixture("pokemons.json").read)
      end

      before { expect(PokemonApi::Graphql::V7::Client).to receive(:query).and_return(response) }

      it "creates multiple pokemon" do
        expect {
          described_class.run
        }.to change(::BasePokemon, :count).from(0).to(3)

        attributes = ::BasePokemon.all.map(&:attributes).map(&:symbolize_keys)

        expect(attributes).to match_array(
          [
            a_hash_including(
              name: "Bulbasaur",
              slug: "bulbasaur",
              base_catch_rate: 45,
              evolution_level: nil,
              evolves_from: nil,
              description: "For some time after its birth, it grows by taking nourishment from the seed on its back.",
              height: 0.7,
              weight: 6.9,
              hp: 45,
              attack: 49,
              special_attack: 65,
              defense: 49,
              special_defense: 65,
              speed: 45,
              dex_index: 1,
              sprite: "https://play.pokemonshowdown.com/sprites/ani/bulbasaur.gif"
            ),
            a_hash_including(
              slug: "ivysaur"
            ),
            a_hash_including(
              slug: "venusaur"
            )
          ]
        )
      end

      it "sets the correct (possible) moves for each pokemon" do
        expect {
          described_class.run
        }.to change(::Move, :count).from(0).to(36)

        bulbasaur = ::BasePokemon.first
        ivysaur = ::BasePokemon.second
        venusaur = ::BasePokemon.last

        expect(bulbasaur.moves.size).to eql 25
        expect(ivysaur.moves.size).to eql 11
        expect(venusaur.moves.size).to eql 11

        attributes = ::Move.all.map(&:attributes).map(&:symbolize_keys)

        expect(attributes).to match_array(
          [
            a_hash_including(
              slug: "growl",
              name: "Growl",
              accuracy: 100,
              base_power: 0,
              pp: 40,
              description: "Lowers the foe(s) Attack by 1.",
              max_move_power: nil,
              z_move_power: 0,
              generation: 3,
              level: 4
            ),
            a_hash_including(name: "Growth", level: 32),
            a_hash_including(name: "Leech Seed", level: 7),
            a_hash_including(name: "Poison Powder", level: 15),
            a_hash_including(name: "Razor Leaf", level: 20),
            a_hash_including(name: "Sleep Powder", level: 15),
            a_hash_including(name: "Solar Beam", level: 46),
            a_hash_including(name: "Sweet Scent", level: 25),
            a_hash_including(name: "Synthesis", level: 39),
            a_hash_including(name: "Tackle", level: 1),
            a_hash_including(name: "Vine Whip", level: 10),
            a_hash_including(name: "Double-Edge", level: 27),
            a_hash_including(name: "Growl", level: 3),
            a_hash_including(name: "Growth", level: 25),
            a_hash_including(name: "Leech Seed", level: 7),
            a_hash_including(name: "Poison Powder", level: 13),
            a_hash_including(name: "Razor Leaf", level: 19),
            a_hash_including(name: "Seed Bomb", level: 37),
            a_hash_including(name: "Sleep Powder", level: 13),
            a_hash_including(name: "Sweet Scent", level: 21),
            a_hash_including(name: "Synthesis", level: 33),
            a_hash_including(name: "Tackle", level: 1),
            a_hash_including(name: "Take Down", level: 15),
            a_hash_including(name: "Vine Whip", level: 9),
            a_hash_including(name: "Worry Seed", level: 31),
            a_hash_including(name: "Growl", level: 1),
            a_hash_including(name: "Growth", level: 38),
            a_hash_including(name: "Leech Seed", level: 1),
            a_hash_including(name: "Razor Leaf", level: 22),
            a_hash_including(name: "Solar Beam", level: 56),
            a_hash_including(name: "Sweet Scent", level: 29),
            a_hash_including(name: "Synthesis", level: 47),
            a_hash_including(name: "Growth", level: 41),
            a_hash_including(name: "Solar Beam", level: 65),
            a_hash_including(name: "Synthesis", level: 53),
            a_hash_including(name: "Vine Whip", level: 1)
          ]
        )
      end

      it "sets the correct abilities for each pokemon" do
        expect {
          described_class.run
        }.to change(::Ability, :count).from(0).to(1)

        ability = ::Ability.first

        expect(ability.base_pokemons.size).to eql 3

        expect(ability.attributes.symbolize_keys).to match(
          a_hash_including(
            name: "Overgrow",
            slug: "overgrow",
            description: "At 1/3 or less of its max HP, this Pokémon's attacking stat is 1.5x with Grass attacks."
          )
        )
      end
    end
  end
end
