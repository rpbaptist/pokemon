module Battles
  class EscapeAttempt
    def initialize(battle)
      @battle = battle
    end

    def call
      @battle.escape! if successful?
    end

    private

    def successful?
      rand < 0.5
    end
  end
end
