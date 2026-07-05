module Battles
  class OpponentFleeAttempt
    def successful?
      rand < 0.3
    end
  end
end
