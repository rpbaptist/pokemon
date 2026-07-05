module Battles
  class CaptureAttempt
    def initialize(battle)
      @battle = battle
    end

    def call
      if successful?
        @battle.capture!
      elsif OpponentFleeAttempt.new.successful?
        @battle.opponent_flee!
      end
    end

    private

    def successful?
      rand < 0.5
    end
  end
end
