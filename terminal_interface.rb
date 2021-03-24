# frozen_string_literal: true

class TerminalInterface
  ACTION_GAME = <<~HERE
    Ход игрока:
    1. Пропустить ход
    2. Добавить карту
    3. Открыть карты
  HERE

  MENU_RESTART = <<~HERE
    Выберите нужное действие
    1. Начать новую игру
    2. Закончить игру
  HERE

  INFO_LABEL = 'Выберите нужное действие'

  def set_player
    puts 'Введите имя:'
    gets.chomp
  end

  def show_error(err)
    puts "#{err.message}\nПовторите попытку!"
  end

  def show_cards_player(user, options = { hidden: false })
    if options[:hidden]
      cards = score = purse = '***'
    else
      cards = user.hand.to_s
      score = user.hand.total_points
      purse = user.purse
    end
    puts "У игрока #{user.name}, Карты: #{cards}. Очков: #{score} В кошельке: #{purse}$"
  end

  def show_open_cards(user)
    puts "Игрок #{user.name} выбрал открыть карты."
  end

  def show_skip(user)
    puts "#{user.name} пропустил ход!"
  end

  def show_menu_player
    puts ACTION_GAME
    gets.chomp.to_i
  end

  def game_over
    puts 'Игра завершена!'
  end

  def restart_game
    puts MENU_RESTART
    gets.chomp.to_i
  end

  def show_ponits(user, options = { hidden: false })
    sum = options[hidden] ? '***' : user.purse
    puts "Сумма в кошельке у #{user.name}: #{sum}$"
  end

  def show_add_card(user)
    puts "Игрок #{user.name} взял карту"
  end

  def show_move_player(user)
    puts "Ход #{user.name}..."
  end

  def show_winner(winner, bank)
    puts "Выйграл: #{winner.name}, Выйгрыш: #{bank}$"
  end

  def not_winner
    puts 'Все проиграли!'
  end

  def show_evil(rate)
    puts "Ничья! Выйгрыш: по #{rate}$"
  end

  def show_start_game(bank, rate)
    puts 'Начинаем игру!'
    puts "В банке: #{bank}$, ставка: #{rate}$"
  end

  def show_result_game
    print 'Результат игры: '
  end

  def show_info_label
    puts INFO_LABEL
  end
end
