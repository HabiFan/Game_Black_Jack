# frozen_string_literal: true

class Deck
  SUITS = ["\u{2660}", "\u{2663}", "\u{2665}", "\u{2666}"].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  attr_reader :cards

  def initialize
    create_deck
  end

  def give_card(number)
    @cards.sample(number).each { |item| @cards.delete(item) }
  end

  def create_deck
    @cards = build_deck
  end

  private

  def build_deck
    RANKS.flat_map { |rank| SUITS.flat_map { |suit| Card.new(rank, suit) } }
  end
end
