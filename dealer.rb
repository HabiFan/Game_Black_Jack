# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  def initialize
    super('Dealer', :dealer)
  end
end
