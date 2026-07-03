require "rails_helper"

RSpec.describe BasePokemon, type: :model do
  describe "#stat_at_level" do
    let(:base_pokemon) { BasePokemon.new(hp: 35, attack: 55) }

    it "computes hp with the level and +10 bonus" do
      expect(base_pokemon.stat_at_level(:hp, 10)).to eq((2 * 35 * 10 / 100) + 10 + 10)
    end

    it "computes other stats with the +5 bonus" do
      expect(base_pokemon.stat_at_level(:attack, 10)).to eq((2 * 55 * 10 / 100) + 5)
    end
  end
end
