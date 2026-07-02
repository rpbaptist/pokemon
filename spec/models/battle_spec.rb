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

    %w[victory defeat captured].each do |terminal_state|
      it "cannot be called once the battle has ended in #{terminal_state}" do
        battle = battle_in(terminal_state)

        expect { battle.escape! }.to raise_error(AASM::InvalidTransition)
      end
    end
  end
end
