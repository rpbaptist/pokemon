module PokemonApi
  module Graphql
    module V7
      module Requests
        class TypeMatchups
          def self.retrieve(primary_type:, secondary_type: nil)
            response = PokemonApi::Graphql::V7::Client.query(
              <<~GRAPHQL
                query {
                  getTypeMatchup(primaryType: #{primary_type}, secondaryType: #{secondary_type || primary_type}) {
                    attacking {
                      doubleEffectiveTypes
                      doubleResistedTypes
                      effectiveTypes
                      effectlessTypes
                      resistedTypes
                    }
                    defending {
                      doubleEffectiveTypes
                      doubleResistedTypes
                      effectiveTypes
                      effectlessTypes
                      resistedTypes
                    }
                  }
                }
              GRAPHQL
            )

            response.dig("data", "getTypeMatchup") || []
          end
        end
      end
    end
  end
end
