class BasePokemon < ApplicationRecord
  has_many :pokemons

  has_and_belongs_to_many :abilities
  has_and_belongs_to_many :moves

  serialize :pokemon_types, Array

  BASE_STAT_MULTIPLIER = 2
  LEVEL_SCALE_DIVISOR = 100
  HP_LEVEL_BONUS = 10
  STAT_BONUS = 5

  def stat_at_level(stat_name, level)
    scaled = calculate_scaled_stat(stat_name, level)

    if stat_name.to_sym == :hp
      scaled + level + HP_LEVEL_BONUS
    else
      scaled + STAT_BONUS
    end
  end

  private

  def calculate_scaled_stat(stat_name, level)
    base = self[stat_name]
    BASE_STAT_MULTIPLIER * base * level / LEVEL_SCALE_DIVISOR
  end
end
