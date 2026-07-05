class Battles::CaptureAttemptsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

  def create
    @battle = Battle.find(params[:battle_id])
    @captured = Battles::CaptureAttempt.new.successful?

    if @captured
      @fled = false
      @battle.capture!
    else
      @fled = Battles::OpponentFleeAttempt.new.successful?
      @battle.opponent_flee! if @fled
    end

    render turbo_stream: turbo_stream.replace(
      ActionView::RecordIdentifier.dom_id(@battle, :actions),
      partial: "battles/actions",
      locals: {battle: @battle, escaped: nil, captured: @captured, fled: @fled}
    )
  end
end
