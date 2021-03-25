# frozen_string_literal: true

class Card
  SUITS = ["\u{2660}", "\u{2663}", "\u{2665}", "\u{2666}"].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def rating_card
    case @rank
    when /[JQK]/ then 10
    when /A/ then 11
    else
      @rank.to_i
    end
  end
end
