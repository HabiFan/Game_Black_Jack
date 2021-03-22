# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

require_relative 'modules'
require_relative 'card'
require_relative 'player'

class Game
  include Validation
  include GameLabels

  def initialize
    @bank = 0
    @rate = 10
    @cards = Card.new
    start_game
  end

  def start_game
    @dealer = Player.new('Dealer', :dealer)
    puts 'Ваше имя?: '
    @player = Player.new(gets.chomp.to_s)
    start_new_game
  end

  private

  def start_new_game
    end_game if (@dealer.purse || @player.purse) <= 0
    puts 'Начало игры!'
    @cards.start_deck
    @dealer.spend_purse(@rate)
    @player.spend_purse(@rate)
    @bank = @rate * 2
    puts "Сумма в банке: #{@bank}$"
    add_card(@dealer, 2)
    add_card(@player, 2)
    choice_player
  end

  def add_card(player, num_card = 1)
    puts "Игрок #{player.name} взял карту"
    player.add_card(@cards.give_card(num_card))
    puts player.to_s(show: !player.dealer?).to_s
    game_result if @dealer.cards.size == 3 && @player.cards.size == 3
    choice_action(player) unless num_card > 1
  end

  def choice_action(player)
    player.dealer? ? choice_player : choice_dealer
  end

  def skip(player)
    puts "Игрок #{player.name} пропустил ход."
    choice_action(player)
  end

  def open_card(player)
    puts "Игрок #{player.name} выбрал открыть карты."
    game_result
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize

  def game_result
    if (@player.total_points <= 21) && ((21 - @player.total_points).abs < (21 - @dealer.total_points).abs)
      winner(@player)
    elsif ((21 - @player.total_points) == (21 - @dealer.total_points)) &&
          (@player.total_points <= 21 && @dealer.total_points <= 21)
      winner(@player, @dealer)
    elsif @dealer.total_points <= 21
      winner(@dealer)
    else
      puts 'Все проиграли!'
      end_game
    end
  end

  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def choice_player
    loop do
      puts ACTION_GAME
      case gets.chomp.to_i
      when 1 then skip(@player)
      when 2 then add_card(@player, 1)
      when 3 then open_card(@player)
      else
        puts INFO_LABEL; end
    end
  end

  def choice_dealer
    puts 'Ход игрока Дилера: '
    @dealer.total_points >= 17 ? skip(@dealer) : add_card(@dealer, 1)
  end

  def winner(*players)
    print 'Результат игры: '
    if players.size > 1
      puts "Ничья! Выйгрыш: по #{@rate}$"
      players.each { |player| player.spend(@rate) }
    else
      puts "Выграл #{players.first.name}! Выйгрыш: #{@bank}$"
      players.first.purse_add(@bank)
    end
    end_game
  end

  def info_game(options = { show_dealer: false })
    puts "Дилер: #{@dealer.to_s(show: options[:show_dealer])}"
    puts "Игрок (#{@player.name}): #{@player}"
  end

  def end_game
    info_game(show_dealer: true)
    @bank = 0
    @dealer.reset_cards
    @player.reset_cards
    restart_game
  end

  def restart_game
    puts MENU_GAME
    loop do
      case gets.chomp.to_i
      when 1 then start_new_game
      when 2 then exit!
      else
        puts INFO_LABEL; end
    end
  end
end

# rubocop:enable Metrics/ClassLength

Game.new
