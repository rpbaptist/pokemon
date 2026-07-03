class Trainer < ApplicationRecord
  has_many :pokemons

  DEFAULT_TRAINER_NAME = "Ash Ketchum"

  class << self
    def default
      @default ||= find_by(name: DEFAULT_TRAINER_NAME)
    end
  end
end
