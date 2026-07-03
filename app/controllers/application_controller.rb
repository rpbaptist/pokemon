class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :current_trainer

  private

  def current_trainer
    Trainer.default
  end
end
