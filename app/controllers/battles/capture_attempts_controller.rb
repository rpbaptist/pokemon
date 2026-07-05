class Battles::CaptureAttemptsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

  def create
    @battle = Battle.find(params[:battle_id])
    Battles::CaptureAttempt.new(@battle).call

    render turbo_stream: turbo_stream.update(
      ActionView::RecordIdentifier.dom_id(@battle, :actions),
      partial: "battles/actions",
      locals: {battle: @battle, escaped: nil, captured: @battle.captured?, fled: @battle.fled?}
    )
  end
end
