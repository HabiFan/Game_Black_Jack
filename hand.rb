class Hand
  attr_accessor :cards, :total_score

  def initialize
    @cards = []
    @total_points = 0
  end

  def total_points
    return if cards.empty? || cards.nil?

    scope_cards
  end

  def scope_cards
    points = 0
    @cards.each do |card|
      if card.rating_card == 11
        points += (points + 11) > 21 ? 1 : 11
      else
        points += card.rating_card
      end
    end
    @total_points = points
  end

  def reset_cards
    @cards.clear
  end

  def to_s
    "#{print_cards { |card|  "#{card.rank}#{card.suit}" }}"
  end

  private

  def print_cards(&block)
    @cards.map(&block).join(", ") if block_given?
  end

end
