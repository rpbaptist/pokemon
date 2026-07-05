require "rails_helper"

RSpec.describe "Battles", type: :request do
  describe "GET /battles/new" do
    let!(:trainer) { Trainer.create!(name: "Ash Ketchum") }
    let(:base_pokemon) { BasePokemon.create!(name: "Rattata", slug: "rattata", sprite: "https://example.com/rattata.png") }
    let(:opponent) { Pokemon.create!(base_pokemon: base_pokemon, trainer: nil, level: 3) }

    it "uses the default trainer" do
      get new_battle_path(battle_type: "pve", opponent_id: opponent.id)

      expect(response.body).to include(trainer.name)
    end
  end
end
