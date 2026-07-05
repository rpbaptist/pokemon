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
      expect(battle_in("start")).to transition_from(:start).to(:escaped).on_event(:escape).on(:battle)
    end

    it "transitions from move_selection to escaped" do
      expect(battle_in("move_selection")).to transition_from(:move_selection).to(:escaped).on_event(:escape).on(:battle)
    end

    it "cannot be called again once already escaped" do
      expect(battle_in("escaped")).not_to allow_event(:escape).on(:battle)
    end

    %w[victory defeat captured fled].each do |terminal_state|
      it "cannot be called once the battle has ended in #{terminal_state}" do
        expect(battle_in(terminal_state)).not_to allow_event(:escape).on(:battle)
      end
    end
  end

  describe "#capture!" do
    it "transitions from start to captured" do
      expect(battle_in("start")).to transition_from(:start).to(:captured).on_event(:capture).on(:battle)
    end

    it "transitions from move_selection to captured" do
      expect(battle_in("move_selection")).to transition_from(:move_selection).to(:captured).on_event(:capture).on(:battle)
    end

    it "assigns the opponent to the trainer" do
      battle = battle_in("start")

      battle.capture!

      expect(opponent.reload.trainer).to eq(trainer)
    end

    %w[escaped fled victory defeat captured].each do |terminal_state|
      it "cannot be called once the battle has ended in #{terminal_state}" do
        expect(battle_in(terminal_state)).not_to allow_event(:capture).on(:battle)
      end
    end
  end

  describe "#opponent_flee!" do
    it "transitions from start to fled" do
      expect(battle_in("start")).to transition_from(:start).to(:fled).on_event(:opponent_flee).on(:battle)
    end

    it "transitions from move_selection to fled" do
      expect(battle_in("move_selection")).to transition_from(:move_selection).to(:fled).on_event(:opponent_flee).on(:battle)
    end

    %w[escaped fled victory defeat captured].each do |terminal_state|
      it "cannot be called once the battle has ended in #{terminal_state}" do
        expect(battle_in(terminal_state)).not_to allow_event(:opponent_flee).on(:battle)
      end
    end
  end
end
