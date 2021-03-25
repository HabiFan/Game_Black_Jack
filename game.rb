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

  def game_result
    winner(@player) if player_winner?
    winner(@dealer) if dealer_winner?
    winner(@player, @dealer) if evil_game?
    end_game
  end

  def evil_game?
    match_score.zero? && (valid_score(@player) && valid_score(@dealer))
  end

  def not_winner?
    !valid_score(@player) && !valid_score(@dealer)
  end

  def player_winner?
    match_score.positive? && valid_score(@player) || valid_score(@player) && !valid_score(@dealer)
  end

  def dealer_winner?
    match_score.negative? && valid_score(@dealer) || valid_score(@dealer) && !valid_score(@player)
  end

  def valid_score(user)
    (user.hand.total_points <=> 21) <= 0
  end

  def match_score
    @player.hand.total_points <=> @dealer.hand.total_points
  end

  def winner(*players)
    @interface.show_result_game
    if players.size > 1
      @interface.show_evil(@rate)
      players.each { |player| player.purse_add(@rate) }
    else
      @interface.show_winner(players.first, @bank)
      players.first.purse_add(@bank)
    end
    end_game
  end

  def end_game
    @interface.not_winner if not_winner?
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
