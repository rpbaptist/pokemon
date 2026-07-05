require "rails_helper"

RSpec.describe Battle do
  let(:trainer) { Trainer.create!(name: "Ash Ketchum") }
  let(:base_pokemon) { BasePokemon.create!(name: "Rattata", slug: "rattata") }
  let(:opponent) { Pokemon.create!(base_pokemon: base_pokemon, trainer: nil, level: 3) }

  def battle_in(state)
    Battle.create!(trainer: trainer, opponent_id: opponent.id, battle_type: "pve", state: state)
  end

  describe "#escape!" do
    it "transitions from start to escaped" do
      battle = battle_in("start")

      battle.escape!

      expect(battle.state).to eq("escaped")
    end

    it "transitions from move_selection to escaped" do
      battle = battle_in("move_selection")

      battle.escape!

      expect(battle.state).to eq("escaped")
    end

    it "cannot be called again once already escaped" do
      battle = battle_in("escaped")

      expect { battle.escape! }.to raise_error(AASM::InvalidTransition)
    end

    %w[victory defeat captured fled].each do |terminal_state|
      it "cannot be called once the battle has ended in #{terminal_state}" do
        battle = battle_in(terminal_state)

        expect { battle.escape! }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  describe "#capture!" do
    it "transitions from start to captured" do
      battle = battle_in("start")

      battle.capture!

      expect(battle.state).to eq("captured")
    end

    it "transitions from move_selection to captured" do
      battle = battle_in("move_selection")

      battle.capture!

      expect(battle.state).to eq("captured")
    end

    it "assigns the opponent to the trainer" do
      battle = battle_in("start")

      battle.capture!

      expect(opponent.reload.trainer).to eq(trainer)
    end

    %w[escaped fled victory defeat captured].each do |terminal_state|
      it "cannot be called once the battle has ended in #{terminal_state}" do
        battle = battle_in(terminal_state)

        expect { battle.capture! }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  describe "#opponent_flee!" do
    it "transitions from start to fled" do
      battle = battle_in("start")

      battle.opponent_flee!

      expect(battle.state).to eq("fled")
    end

    it "transitions from move_selection to fled" do
      battle = battle_in("move_selection")

      battle.opponent_flee!

      expect(battle.state).to eq("fled")
    end

    %w[escaped fled victory defeat captured].each do |terminal_state|
      it "cannot be called once the battle has ended in #{terminal_state}" do
        battle = battle_in(terminal_state)

        expect { battle.opponent_flee! }.to raise_error(AASM::InvalidTransition)
      end
    end
  end
end
