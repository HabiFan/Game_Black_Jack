# frozen_string_literal: true

require_relative 'modules'

class Player
  include Validation

  attr_reader :name, :type_player, :purse, :cards

  validate :cards, :max_length, 3
  validate :name, :type, String
  validate :type_player, :type, Symbol
  validate :name, :presence
  validate :name, :min_length, 3

  def initialize(name, type_player = :player)
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
    return if cards.empty? || cards.nil?

    scope_cards(cards)
  end

  # rubocop:disable Metrics/MethodLength

  def scope_cards(cards)
    points = 0
    cards.each do |card|
      points += case card[0]
                when /[1JQK]/
                  10
                when /A/
                  (points + 11) > 21 ? 1 : 11
                else
                  card[0].to_i
                end
    end
    points
  end

  # rubocop:enable Metrics/MethodLength

  def dealer?
    @type_player == :dealer
  end

  def reset_cards
    @cards.clear
  end

  def purse_add(sum)
    @purse += sum
  end

  def spend_purse(sum)
    @purse -= sum
  end

  def to_s(options = { show: true })
    if options[:show]
      show_cards = cards.join(', ')
      show_points = total_points
      show_purse = @purse
    else
      show_cards = show_points = show_purse = '***'
    end
    "Карты: #{show_cards}. Набранные очки: #{show_points} Сумма в кошельке: #{show_purse}$"
  end

  private

  attr_writer :name, :type_player, :purse
end
