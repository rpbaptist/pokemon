require "rails_helper"

RSpec.describe Battles::CaptureAttempt do
  let(:trainer) { Trainer.create!(name: "Ash Ketchum") }
  let(:base_pokemon) { BasePokemon.create!(name: "Rattata", slug: "rattata") }
  let(:opponent) { Pokemon.create!(base_pokemon: base_pokemon, trainer: nil, level: 3) }
  let(:battle) { Battle.create!(trainer: trainer, opponent_id: opponent.id, battle_type: "pve") }

  describe "#call" do
    context "when the catch succeeds" do
      before { allow_any_instance_of(described_class).to receive(:successful?).and_return(true) }

      it "transitions the battle to captured and assigns the opponent to the trainer" do
        described_class.new(battle).call

        expect(battle.reload).to have_state(:captured).on(:battle)
        expect(opponent.reload.trainer).to eq(trainer)
      end
    end

    context "when the catch fails and the opponent flees" do
      before do
        allow_any_instance_of(described_class).to receive(:successful?).and_return(false)
        allow_any_instance_of(Battles::OpponentFleeAttempt).to receive(:successful?).and_return(true)
      end

      it "transitions the battle to fled" do
        described_class.new(battle).call

        expect(battle.reload).to have_state(:fled).on(:battle)
      end
    end

    context "when the catch fails and the opponent does not flee" do
      before do
        allow_any_instance_of(described_class).to receive(:successful?).and_return(false)
        allow_any_instance_of(Battles::OpponentFleeAttempt).to receive(:successful?).and_return(false)
      end

      it "leaves the battle state unchanged" do
        described_class.new(battle).call

        expect(battle.reload).to have_state(:start).on(:battle)
      end
    end
  end
end
