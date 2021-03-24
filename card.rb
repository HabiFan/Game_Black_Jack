# frozen_string_literal: true

class Card
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
