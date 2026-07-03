module Import
  class BasePokemonImporter
    def self.run
      api_pokemons = PokemonApi::Graphql::V7::Requests::Pokemons.retrieve

      api_pokemons.each do |api_pokemon|
        # NOTE: Ignore other Pokemon forms (such as gmax) for now
        next if api_pokemon["forme"].present?

        pokemon = import_pokemon(api_pokemon)

        importer = new(pokemon, api_pokemon)

        importer.import_and_link_abilities
        importer.import_and_link_moves
      end

      true
    end

    def self.import_pokemon(api_pokemon)
      api_base_stats = api_pokemon["baseStats"]

      base_pokemon = ::BasePokemon.find_or_create_by(
        dex_index: api_pokemon["num"],
        name: api_pokemon["key"].try(:titleize),
        slug: api_pokemon["key"]
      )

      base_pokemon.update(
        description: Array(api_pokemon["flavorTexts"]).pluck("flavor").first,
        pokemon_types: Array(api_pokemon["types"]).pluck("name").compact,
        sprite: api_pokemon["sprite"],
        base_catch_rate: api_pokemon.dig("catchRate", "base"),
        levelling_rate: api_pokemon["levellingRate"],
        evolves_from: Array(api_pokemon["preevolutions"]).pluck("key").first,
        evolution_level: api_pokemon["evolutionLevel"],
        height: api_pokemon["height"],
        weight: api_pokemon["weight"],
        attack: api_base_stats["attack"],
        defense: api_base_stats["defense"],
        hp: api_base_stats["hp"],
        special_attack: api_base_stats["specialattack"],
        special_defense: api_base_stats["specialdefense"],
        speed: api_base_stats["speed"]
      )

      base_pokemon
    end

    attr_reader :pokemon, :api_pokemon

    def initialize(pokemon, api_pokemon)
      @pokemon = pokemon
      @api_pokemon = api_pokemon
    end

    def import_and_link_abilities
      api_abilities = Array(api_pokemon["abilities"])

      abilities = api_abilities.map do |_, api_ability|
        Ability.find_or_create_by(
          slug: api_ability["key"],
          name: api_ability["name"],
          description: api_ability["shortDesc"]
        )
      end

      pokemon.abilities = abilities

      true
    end

    def import_and_link_moves
      api_learn_sets = Array(api_pokemon["learnsets"])

      api_learn_sets.each do |_, value|
        Array(value["levelUpMoves"]).each do |api_level_up_move|
          api_move = api_level_up_move["move"]

          move = Move.find_or_create_by(
            slug: api_move["key"],
            name: api_move["name"],
            accuracy: api_move["accuracy"],
            base_power: api_move["basePower"],
            pp: api_move["pp"],
            description: api_move["shortDesc"],
            max_move_power: api_move["maxMovePower"],
            z_move_power: api_move["zMovePower"],
            generation: api_level_up_move["generation"],
            level: api_level_up_move["level"],
            pokemon_type: api_move["type"]
          )

          pokemon.moves << move
        end
      end

      true
    end
  end
end
