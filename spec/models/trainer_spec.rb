require 'rails_helper'

RSpec.describe Trainer, type: :model do
  fixtures :trainers

  describe "#default" do
    it 'returns the default trainer' do
      expect(Trainer.default.name).to eq(Trainer::DEFAULT_TRAINER_NAME)
    end
  end
end
