class Trainer < ApplicationRecord
  has_many :pokemons

  DEFAULT_TRAINER_NAME = "Ash Ketchum"

  def self.default
    find_by(name: DEFAULT_TRAINER_NAME)
  end
end
