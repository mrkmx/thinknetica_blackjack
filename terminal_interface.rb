# frozen_string_literal: true

require_relative 'game'

class TerminalInterface
  def initialize
    puts 'Введите своё имя'
    player_name = gets.chomp

    @game = Game.new(player_name)
    @game.start
    output
  end

  def output
    player_status
    dealer_status
    menu_user_actions
  end

  def player_status
    puts "#{@game.player.name}: #{@game.player.card_names}"
    puts "Очки: #{@game.player.score}, Деньги: #{@game.player.money}"
    puts '========================='
  end

  def dealer_status
    puts "#{@game.dealer.name}: #{@game.dealer.card_masked_names}"
    puts "Деньги: #{@game.dealer.money}"
    puts '========================='
  end

  def menu_user_actions
    if @game.max_cards? @game.player
      puts '1 - пропустить ход, 2 - показать карты'
    else
      puts '1 - пропустить ход, 2 - показать карты, 3 - взять карту'
    end

    input = gets.chomp.to_i
    case input
    when 1
      skip_turn
    when 2
      show_cards
    when 3
      take_card
    else
      puts 'Неизвестная команда'
      menu_user_actions
    end
  end

  def menu_continue
    @game.users.each do |user|
      next unless @game.bankrupt? user

      puts "#{user.name} не может сделать ставку, игра окончена"
      puts 'Завершение игры'
      exit
    end

    puts 'Продолжить? (y/n)'
    input = gets.chomp
    if input == 'y'
      continue_game
    elsif input == 'n'
      puts 'Завершение игры'
      exit
    else
      puts 'Неизвестная команда'
      menu_continue
    end
  end

  def continue_game
    @game.users.each do |user|
      user.remove_cards
      user.remove_score
    end
    @game.start
    output
  end

  def skip_turn
    dealer_actions_view
    show_cards if @game.over?
    output
  end

  def show_cards
    winner = @game.winner
    if winner
      @game.reward winner
      winner_view winner
    else
      @game.reward(@game.users)
      draw_view
    end
    menu_continue
  end

  def winner_view(winner)
    puts "Победил #{winner.name}"
    puts "#{@game.player.name}: #{@game.player.score}, #{@game.player.card_names}"
    puts "#{@game.dealer.name}: #{@game.dealer.score}, #{@game.dealer.card_names}"
  end

  def draw_view
    puts 'Ничья'
    puts "#{@game.dealer.name}: #{@game.dealer.score}, #{@game.dealer.card_names}"
    puts "#{@game.player.name}: #{@game.player.score}, #{@game.player.card_names}"
  end

  def take_card
    @game.take_player_card
    show_cards if @game.over?
    dealer_actions_view
    output
  end

  def dealer_actions_view
    response = @game.dealer_actions ? 'Дилер берет карту' : 'Дилер пропускает ход'
    puts '========================='
    puts response
    puts '========================='
  end
end
