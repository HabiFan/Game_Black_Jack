# frozen_string_literal: true

class Deck
  attr_reader :cards

  def initialize
    create_deck
  end

  def give_card(number)
    @cards.sample(number).each { |item| @cards.delete(item) }
  end

  def create_deck
    @cards = Card::RANKS.flat_map { |rank| Card::SUITS.flat_map { |suit| Card.new(rank, suit) } }
  end
end
