class Trainer < ApplicationRecord
  has_many :pokemons do
    def highest_level
      order(level: :desc).first
    end
  end

  DEFAULT_TRAINER_NAME = "Ash Ketchum"

  def self.default
    find_by(name: DEFAULT_TRAINER_NAME)
  end
end
