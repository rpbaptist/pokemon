module PokemonApi
  module Graphql
    module V7
      class Client
        include HTTParty

        base_uri ENV["POKEMON_API_URI"]

        class << self
          def query(query)
            post(
              "/",
              body: {query: query}.to_json,
              headers: {"Content-Type": "application/json"}
            )
          end
        end
      end
    end
  end
end
