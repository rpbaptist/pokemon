class Battle < ApplicationRecord
  include AASM

  belongs_to :trainer

  has_one :opponent, class_name: "Pokemon", foreign_key: "id", primary_key: "opponent_id"

  enum battle_type: {
    pve: "pve",
    pvp: "pvp"
  }

  aasm(:battle, column: :state) do
    state :start, initial: true
    state :move_selection
    state :escaped
    state :fled
    state :captured
    state :victory
    state :defeat

    event :escape do
      transitions from: [:start, :move_selection], to: :escaped
    end

    event :capture do
      transitions from: [:start, :move_selection], to: :captured, after: :assign_opponent_to_trainer
    end

    event :opponent_flee do
      transitions from: [:start, :move_selection], to: :fled
    end
  end

  private

  def assign_opponent_to_trainer
    opponent.update!(trainer: trainer)
  end
end
