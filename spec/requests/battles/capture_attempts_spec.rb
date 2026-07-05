require "rails_helper"

RSpec.describe "Battles::CaptureAttempts", type: :request do
  describe "POST /battles/:battle_id/capture_attempt" do
    let(:trainer) { Trainer.create!(name: "Ash Ketchum") }
    let(:base_pokemon) { BasePokemon.create!(name: "Rattata", slug: "rattata") }
    let(:opponent) { Pokemon.create!(base_pokemon: base_pokemon, trainer: nil, level: 3) }
    let(:battle) { Battle.create!(trainer: trainer, opponent_id: opponent.id, battle_type: "pve") }

    context "when the capture succeeds" do
      before { allow_any_instance_of(Battles::CaptureAttempt).to receive(:successful?).and_return(true) }

      it "transitions the battle to captured" do
        post battle_capture_attempt_path(battle)

        expect(response).to have_http_status(:ok)
        expect(battle.reload).to have_state(:captured).on(:battle)
      end

      it "assigns the opponent to the trainer" do
        post battle_capture_attempt_path(battle)

        expect(opponent.reload.trainer).to eq(trainer)
      end

      it "renders a turbo stream announcing the catch" do
        post battle_capture_attempt_path(battle)

        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("You caught it!")
      end
    end

    context "when the capture fails and the opponent flees" do
      before do
        allow_any_instance_of(Battles::CaptureAttempt).to receive(:successful?).and_return(false)
        allow_any_instance_of(Battles::OpponentFleeAttempt).to receive(:successful?).and_return(true)
      end

      it "transitions the battle to fled" do
        post battle_capture_attempt_path(battle)

        expect(response).to have_http_status(:ok)
        expect(battle.reload).to have_state(:fled).on(:battle)
      end

      it "renders a turbo stream announcing the flee" do
        post battle_capture_attempt_path(battle)

        expect(response.body).to include("It fled")
      end
    end

    context "when the capture fails and the opponent does not flee" do
      before do
        allow_any_instance_of(Battles::CaptureAttempt).to receive(:successful?).and_return(false)
        allow_any_instance_of(Battles::OpponentFleeAttempt).to receive(:successful?).and_return(false)
      end

      it "leaves the battle state unchanged" do
        post battle_capture_attempt_path(battle)

        expect(response).to have_http_status(:ok)
        expect(battle.reload).to have_state(:start).on(:battle)
      end

      it "renders a turbo stream announcing the failed attempt" do
        post battle_capture_attempt_path(battle)

        expect(response.body).to include("Capture failed")
      end
    end

    context "when the battle does not exist" do
      it "returns 404" do
        post battle_capture_attempt_path(battle_id: -1)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
