require "rails_helper"

RSpec.describe Trainer, type: :model do
  fixtures :trainers

  describe "#default" do
    it "returns the default trainer" do
      expect(Trainer.default.name).to eq(Trainer::DEFAULT_TRAINER_NAME)
    end
  end

  describe "#pokemons.highest_level" do
    let(:trainer) { Trainer.create!(name: "Ash Ketchum") }
    let(:base_pokemon) { BasePokemon.create!(name: "Rattata", slug: "rattata") }

    it "returns the trainer's highest level pokemon" do
      Pokemon.create!(base_pokemon: base_pokemon, trainer: trainer, level: 5)
      strongest = Pokemon.create!(base_pokemon: base_pokemon, trainer: trainer, level: 12)

      expect(trainer.pokemons.highest_level).to eq(strongest)
    end

    it "returns nil when the trainer has no pokemons" do
      expect(trainer.pokemons.highest_level).to be_nil
    end

    it "ignores other trainers' pokemons" do
      Pokemon.create!(base_pokemon: base_pokemon, trainer: trainer, level: 3)
      other_trainer = Trainer.create!(name: "Misty")
      Pokemon.create!(base_pokemon: base_pokemon, trainer: other_trainer, level: 99)

      expect(trainer.pokemons.highest_level.level).to eq(3)
    end
  end
end
