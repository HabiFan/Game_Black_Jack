require_relative 'modules'

class Player
  include Validation

  attr_reader :name, :type_player, :purse, :cards

  validate :cards, :max_length, 3
  validate :name, :type, String
  validate :type_player, :type, Symbol
  validate :name, :presence
  validate :name, :min_length, 3

  def initialize(name, type_player=:player)
    @name = name
    @type_player = type_player
    @purse = 100
    @cards ||= []
    validate!
  end

  def add_card(card)
    cards.concat(card) unless (cards.size + card.size) > 3
  end

  def total_points
    unless cards.empty? || cards.nil?
      points = 0
      cards.each do |card|
        if card[0] =~/[1JQK]/
          points += 10
        elsif card[0] =~/[A]/
          points += (points + 11) > 21 ? 1 : 11
        else
          points += card[0].to_i
        end
      end
      return points
    end
  end

  def dealer?; @type_player == :dealer; end

  def reset_cards; @cards.clear; end

  def set_purse(sum); @purse += sum; end

  def spend_purse(sum) @purse -= sum; end

  def to_s(show=true)
    if show
      show_cards, show_points, show_purse = cards.join(", "), total_points, @purse
    else
      show_cards = show_points = show_purse = '***'
    end
    "Карты: #{show_cards}. Набранные очки: #{show_points} Сумма в кошельке: #{show_purse}$"
  end

  private

  attr_writer :name, :type_player, :purse

end
