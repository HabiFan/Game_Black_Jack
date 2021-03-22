# frozen_string_literal: true

require_relative 'modules'
require_relative 'card'
require_relative 'player'

class Game
  include Validation

  ACTION_GAME = <<~HERE
    Выберите нужное действие
    1. Пропустить ход
    2. Добавить карту
    3. Открыть карты
  HERE

  INFO_LABEL = 'Выберите нужное действие'

  MENU_GAME = <<~HERE
    Выберите нужное действие
    1. Начать новую игру
    2. Закончить игру
  HERE

  def initialize
    @bank = 0
    @rate = 10
    @stop_game = false
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
    choice_action(@player)
  end

  def add_card(player, num_card = 1)
    puts "Игрок #{player.name} взял карту"
    player.add_card(@cards.give_card(num_card))
    puts player.to_s(show: !player.dealer?).to_s
    game_result if (@dealer.cards.size == 3) && (@player.cards.size == 3)
  end

  def choice_action(player)
    if player.dealer?
      puts 'Ход дилера:'
      choice_dealer
    else
      puts "Ход игрока #{@player.name}: "
      choice_player
    end
  end

  def skip(player)
    puts "Игрок #{player.name} пропустил ход."
    if player.dealer?
      choice_action(@player)
    else
      choice_action(@dealer)
    end
  end

  def open_card(player)
    puts "Игрок #{player.name} выбрал открыть карты."
    game_result
  end

  def game_result
    @stop_game = true
    if (result_points(@player) < result_points(@dealer)) && (@player.total_points <= 21)
      winner(@player)
    elsif (result_points(@player) == result_points(@dealer)) && (@player.total_points && @dealer.total_points <= 21)
      winner(@player, @dealer)
    elsif @dealer.total_points <= 21
      winner(@dealer)
    else
      puts 'Все проиграли!'
      end_game
    end
  end

  def choice_player
    loop do
      puts ACTION_GAME
      case gets.chomp.to_i
      when 1 then skip(@player)
      when 2
        add_card(@player, 1)
        choice_dealer
      when 3 then open_card(@player)
      else
        puts INFO_LABEL; end
      break if @stop_game
    end
  end

  def choice_dealer
    if @dealer.total_points >= 17
      skip(@dealer)
    elsif @dealer.cards.size == 3
      open_card(@dealer)
    else
      add_card(@dealer, 1)
      choice_player
    end
  end

  def result_points(player)
    21 - player.total_points
  end

  def winner(*args)
    print 'Результат игры: '
    if args.count > 1
      puts "Ничья! Выйгрыш: по #{@rate}$"
      args.each do |player|
        player.purse_add(@rate)
        puts "Игрок #{player.name}: #{player}"
      end
    else
      puts "Выграл #{args[0].name}! Выйгрыш: #{@bank}$"
      args[0].purse_add(@bank)
      info_game(show_dealer: true)
    end
    end_game
  end

  def info_game(options = { show_dealer: false })
    puts "Дилер: #{@dealer.to_s(show: options[:show_dealer])}"
    puts "Игрок (#{@player.name}): #{@player}"
  end

  def end_game
    @bank = 0
    @dealer.reset_cards
    @player.reset_cards
    restart_game
  end

  def restart_game
    loop do
      puts MENU_GAME
      case gets.chomp.to_i
      when 1 then start_new_game
      when 2 then @stop_game = true
      else
        puts INFO_LABEL; end
      break if @stop_game
    end
  end
end
