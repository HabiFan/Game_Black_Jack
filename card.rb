class Card
  attr_reader :deck

  DECK_CARDS = [ "2\u{2660}", "2\u{2663}", "2\u{2665}", "2\u{2666}",
                 "3\u{2660}", "3\u{2663}", "3\u{2665}", "3\u{2666}",
                 "4\u{2660}", "4\u{2663}", "4\u{2665}", "4\u{2666}",
                 "5\u{2660}", "5\u{2663}", "5\u{2665}", "5\u{2666}",
                 "6\u{2660}", "6\u{2663}", "6\u{2665}", "6\u{2666}",
                 "7\u{2660}", "7\u{2663}", "7\u{2665}", "7\u{2666}",
                 "8\u{2660}", "8\u{2663}", "8\u{2665}", "8\u{2666}",
                 "9\u{2660}", "9\u{2663}", "9\u{2665}", "9\u{2666}",
                 "10\u{2660}", "10\u{2663}", "10\u{2665}", "10\u{2666}",
                 "J\u{2660}", "J\u{2663}", "J\u{2665}", "J\u{2666}",
                 "Q\u{2660}", "Q\u{2663}", "Q\u{2665}", "Q\u{2666}",
                 "K\u{2660}", "K\u{2663}", "K\u{2665}", "K\u{2666}",
                 "A\u{2660}", "A\u{2663}", "A\u{2665}", "A\u{2666}"
               ]

  def initialize
    start_deck
  end

  def give_card(number)
    cards = @deck.sample(number)
    cards.each { |item| @deck.delete(item) }
    return cards
  end

  def start_deck
    @deck = DECK_CARDS
  end
end