require "rails_helper"

RSpec.describe Battles::EscapeAttempt do
  let(:trainer) { Trainer.create!(name: "Ash Ketchum") }
  let(:base_pokemon) { BasePokemon.create!(name: "Rattata", slug: "rattata") }
  let(:opponent) { Pokemon.create!(base_pokemon: base_pokemon, trainer: nil, level: 3) }
  let(:battle) { Battle.create!(trainer: trainer, opponent_id: opponent.id, battle_type: "pve") }

  describe "#call" do
    context "when successful" do
      before { allow_any_instance_of(described_class).to receive(:successful?).and_return(true) }

      it "transitions the battle to escaped" do
        described_class.new(battle).call

        expect(battle.reload.state).to eq("escaped")
      end
    end

    context "when unsuccessful" do
      before { allow_any_instance_of(described_class).to receive(:successful?).and_return(false) }

      it "leaves the battle state unchanged" do
        described_class.new(battle).call

        expect(battle.reload.state).to eq("start")
      end
    end
  end
end
