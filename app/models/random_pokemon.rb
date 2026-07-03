class RandomPokemon
  STATS = %i[hp attack special_attack defense special_defense speed].freeze
  BASE_ATTRS = {trainer: nil, current_experience: 0, experience_to_level: 0}.freeze

  class << self
    def retrieve(pokemon = nil)
      base_pokemon = BasePokemon.all.sample

      return if base_pokemon.nil?

      level = determine_level(pokemon)

      attrs = build_attrs(base_pokemon, level)

      base_pokemon.pokemons.create(attrs)
    end

    private

    def determine_level(pokemon)
      if pokemon
        rand([pokemon.level - 3, 1].max..(pokemon.level + 3))
      else
        rand(1..4)
      end
    end

    def build_attrs(base_pokemon, level)
      stats = STATS.index_with { |stat| base_pokemon.stat_at_level(stat, level) }
      current_stats = stats.transform_keys { |stat| :"current_#{stat}" }

      BASE_ATTRS.merge(level: level)
        .merge(stats)
        .merge(current_stats)
    end
  end
end
