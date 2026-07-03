require "rails_helper"

module Import
  RSpec.describe TypeMatchupImporter do
    describe ".run" do
      let(:response) do
        {
          "attacking" => {
            "doubleEffectiveTypes" => [],
            "doubleResistedTypes" => [],
            "effectiveTypes" => [
              "dark",
              "ice",
              "normal",
              "rock",
              "steel"
            ],
            "effectlessTypes" => [
              "ghost"
            ],
            "resistedTypes" => [
              "bug",
              "fairy",
              "flying",
              "poison",
              "psychic"
            ]
          },
          "defending" => {
            "doubleEffectiveTypes" => [],
            "doubleResistedTypes" => [],
            "effectiveTypes" => [
              "fairy",
              "flying",
              "psychic"
            ],
            "effectlessTypes" => [],
            "resistedTypes" => [
              "bug",
              "dark",
              "rock"
            ]
          }
        }
      end

      before do
        allow(::TypeMatchup)
          .to receive(:primary_types)
          .and_return("grass" => "grass", "rock" => "rock")

        allow(PokemonApi::Graphql::V7::Requests::TypeMatchups)
          .to receive(:retrieve)
          .and_return(response)
      end

      it "creates a type matchup for each primary type" do
        expect {
          described_class.run
        }.to change(::TypeMatchup, :count).from(0).to(4)

        grass_type_matchup_attributes = ::TypeMatchup.first.attributes.symbolize_keys

        expect(grass_type_matchup_attributes).to match(
          a_hash_including(
            strong_against: [
              "dark",
              "ice",
              "normal",
              "rock",
              "steel"
            ],
            weak_against: [
              "bug",
              "fairy",
              "flying",
              "poison",
              "psychic"
            ],
            effectless_against: [
              "ghost"
            ],
            resistant_to: [
              "bug",
              "dark",
              "rock"
            ],
            vulnerable_to: [
              "fairy",
              "flying",
              "psychic"
            ]
          )
        )
      end
    end
  end
end
