module BattlesHelper
  RESULT_MESSAGES = {
    "captured" => "You caught it!",
    "escaped" => "You escaped!",
    "fled" => "It fled while you tried to catch it!"
  }.freeze

  def battle_result_message(battle)
    RESULT_MESSAGES[battle.state]
  end

  def battle_failure_message(escaped:, captured:)
    if escaped == false
      "Escape failed — try again."
    elsif captured == false
      "Capture failed — try again."
    end
  end
end
