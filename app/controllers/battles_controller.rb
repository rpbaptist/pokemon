class BattlesController < ApplicationController
  def index
    @battles = Battle.all
  end

  def new
    @trainer = current_trainer
    @opponent = Pokemon.find_by(id: params[:opponent_id])

    @battle = Battle.new(
      battle_type: params.fetch(:battle_type, "encounter"),
      opponent: @opponent,
      trainer: @trainer
    )
  end

  def create
    @battle = Battle.new(battle_params)

    if @battle.save
      redirect_to battle_path(@battle)
    else
      redirect_to new_battle_path(battle_params)
    end
  end

  def show
    @battle = Battle.find(params[:id])
  end

  private

  def battle_params
    params
      .require(:battle)
      .permit(
        :battle_type,
        :opponent_id,
        :trainer_id
      )
  end
end
