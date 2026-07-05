require "rails_helper"

RSpec.describe BattlesHelper, type: :helper do
  describe "#battle_result_message" do
    it "returns the catch message for a captured battle" do
      battle = instance_double(Battle, state: "captured")
      expect(helper.battle_result_message(battle)).to eq("You caught it!")
    end

    it "returns nil for a battle still in progress" do
      battle = instance_double(Battle, state: "start")
      expect(helper.battle_result_message(battle)).to be_nil
    end
  end

  describe "#battle_failure_message" do
    it "returns the escape failure message" do
      expect(helper.battle_failure_message(escaped: false, captured: nil)).to eq("Escape failed — try again.")
    end

    it "returns the capture failure message" do
      expect(helper.battle_failure_message(escaped: nil, captured: false)).to eq("Capture failed — try again.")
    end

    it "returns nil when nothing failed" do
      expect(helper.battle_failure_message(escaped: nil, captured: nil)).to be_nil
    end
  end
end
