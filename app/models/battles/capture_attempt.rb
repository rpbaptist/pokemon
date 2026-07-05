module Battles
  class CaptureAttempt
    def successful?
      rand < 0.5
    end
  end
end
