require "rails_helper"

RSpec.describe "Battles::EscapeAttempts", type: :request do
  describe "POST /battles/:battle_id/escape_attempt" do
    let(:trainer) { Trainer.create!(name: "Ash Ketchum") }
    let(:base_pokemon) { BasePokemon.create!(name: "Rattata", slug: "rattata") }
    let(:opponent) { Pokemon.create!(base_pokemon: base_pokemon, trainer: nil, level: 3) }
    let(:battle) { Battle.create!(trainer: trainer, opponent_id: opponent.id, battle_type: "pve") }

    context "when the escape succeeds" do
      before { allow_any_instance_of(Battles::EscapeAttempt).to receive(:successful?).and_return(true) }

      it "transitions the battle to escaped" do
        post battle_escape_attempt_path(battle)

        expect(response).to have_http_status(:ok)
        expect(battle.reload).to have_state(:escaped).on(:battle)
      end

      it "renders a turbo stream announcing the escape" do
        post battle_escape_attempt_path(battle)

        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("You escaped!")
        expect(response.body).to include("Find another Pokémon")
      end
    end

    context "when the escape fails" do
      before { allow_any_instance_of(Battles::EscapeAttempt).to receive(:successful?).and_return(false) }

      it "leaves the battle state unchanged" do
        post battle_escape_attempt_path(battle)

        expect(response).to have_http_status(:ok)
        expect(battle.reload).to have_state(:start).on(:battle)
      end

      it "renders a turbo stream announcing the failed attempt" do
        post battle_escape_attempt_path(battle)

        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("Escape failed")
      end
    end

    context "when the battle does not exist" do
      it "returns 404" do
        post battle_escape_attempt_path(battle_id: -1)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
