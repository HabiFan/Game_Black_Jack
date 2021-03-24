# frozen_string_literal: true

require_relative 'modules'

class Player
  include Validation

  attr_reader :name, :type_player, :purse, :hand

  validate :name, :type, String
  validate :type_player, :type, Symbol
  validate :name, :presence
  validate :name, :min_length, 3

  def initialize(name, type_player = :player)
    @name = name
    @type_player = type_player
    @purse = 100
    @hand = Hand.new
    validate!
  end

  def add_card(card)
    (@hand.cards << card).flatten! unless (@hand.cards.size + card.size) > 3
  end

  def dealer?
    @type_player == :dealer
  end

  def purse_add(sum)
    @purse += sum
  end

  def spend_purse(sum)
    @purse -= sum
  end

  private

  attr_writer :name, :type_player, :purse
end
