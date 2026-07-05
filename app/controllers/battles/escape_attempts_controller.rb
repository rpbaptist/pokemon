class Battles::EscapeAttemptsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

  def create
    @battle = Battle.find(params[:battle_id])
    @escaped = Battles::EscapeAttempt.new.successful?
    @battle.escape! if @escaped

    render turbo_stream: turbo_stream.replace(
      ActionView::RecordIdentifier.dom_id(@battle, :actions),
      partial: "battles/actions",
      locals: {battle: @battle, escaped: @escaped}
    )
  end
end
