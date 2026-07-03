class RandomPokemon
  class << self
    def retrieve(pokemon = nil)
      sample_base_pokemon = BasePokemon.all.sample

      return if sample_base_pokemon.nil?

      level = determine_level(pokemon)

      sample_base_pokemon.pokemons.create(
        trainer: nil,
        level: level,
        hp: 1,
        attack: 1,
        special_attack: 1,
        defense: 1,
        special_defense: 1,
        speed: 1,
        current_hp: 1,
        current_attack: 1,
        current_special_attack: 1,
        current_defense: 1,
        current_special_defense: 1,
        current_speed: 1,
        current_experience: 0,
        experience_to_level: 0
      )
    end

    private

    def determine_level(pokemon)
      if pokemon
        rand([pokemon.level - 3, 1].max..(pokemon.level + 3))
      else
        rand(1..4)
      end
    end
  end
end
