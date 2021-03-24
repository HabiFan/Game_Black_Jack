# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
require_relative 'modules'
require_relative 'terminal_interface'
require_relative 'card'
require_relative 'deck'
require_relative 'dealer'
require_relative 'player'
require_relative 'hand'

class Game
  include Validation

  def initialize
    @bank = 0
    @rate = 10
    @deck = Deck.new
    @interface = TerminalInterface.new
    start_game
  end

  def start_game
    @player = Player.new(@interface.set_player)
  rescue RuntimeError => e
    @interface.show_error(e)
    retry
  ensure
    @dealer = Dealer.new
    start_new_game
  end

  private

  def start_new_game
    end_game if (@dealer.purse || @player.purse) <= 0
    @dealer.spend_purse(@rate)
    @player.spend_purse(@rate)
    @bank = @rate * 2
    @interface.show_start_game(@bank, @rate)
    add_card(@dealer, 2)
    add_card(@player, 2)
    choice_player
  end

  def add_card(user, num_card = 1)
    @interface.show_add_card(user)
    user.add_card(@deck.give_card(num_card))
    @interface.show_cards_player(user, hidden: user.dealer?)
    game_result if @dealer.hand.cards.size == 3 && @player.hand.cards.size == 3
    choice_action(user) unless num_card > 1
  end

  def choice_action(player)
    player.dealer? ? choice_player : choice_dealer
  end

  def skip(user)
    @interface.show_skip(user)
    choice_action(user)
  end

  def open_card(user)
    @interface.show_open_cards(user)
    game_result
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize

  def game_result
    if (@player.hand.total_points <= 21) &&
       ((21 - @player.hand.total_points).abs < (21 - @dealer.hand.total_points).abs)
      winner(@player)
    elsif ((21 - @player.hand.total_points) == (21 - @dealer.hand.total_points)) &&
          (@player.hand.total_points <= 21 && @dealer.hand.total_points <= 21)
      winner(@player, @dealer)
    elsif @dealer.hand.total_points <= 21
      winner(@dealer)
    else
      @interface.not_winner
      end_game
    end
  end

  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def choice_player
    loop do
      case @interface.show_menu_player
      when 1 then skip(@player)
      when 2 then add_card(@player, 1)
      when 3 then open_card(@player)
      else
        @interface.show_info_label; end
    end
  end

  def choice_dealer
    @interface.show_move_player(@dealer)
    @dealer.hand.total_points >= 17 ? skip(@dealer) : add_card(@dealer, 1)
  end

  def winner(*players)
    @interface.show_result_game
    if players.size > 1
      @interface.show_evil(@rate)
      players.each { |player| player.spend(@rate) }
    else
      @interface.show_winner(players.first, @bank)
      players.first.purse_add(@bank)
    end
    end_game
  end

  def end_game
    @interface.show_cards_player(@player)
    @interface.show_cards_player(@dealer)
    @bank = 0
    @dealer.hand.reset_cards
    @player.hand.reset_cards
    @deck.create_deck
    @interface.game_over
    restart_game
  end

  def restart_game
    loop do
      case @interface.restart_game
      when 1 then start_new_game
      when 2 then exit!
      else
        @interface.show_info_label; end
    end
  end
end

# rubocop:enable Metrics/ClassLength

Game.new
