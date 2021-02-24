# frozen_string_literal: true

require_relative 'game'

class TerminalInterface
  def initialize
    puts "Введите своё имя"
    player_name = gets.chomp
    
    @game = Game.new(self, player_name)
    @game.start
  end

  def status
    puts '========================='
    puts "#{@game.player.name}: #{@game.player.card_names}"
    puts "Очки: #{@game.player.score}, Деньги: #{@game.player.money}"
    puts '========================='
    puts "#{@game.dealer.name}: #{@game.dealer.card_masked_names}"
    puts "Деньги: #{@game.dealer.money}"
    puts '========================='
  end

  def user_actions
    if @game.max_cards? @game.player
      puts '1 - пропустить ход, 2 - показать карты'
    else
      puts '1 - пропустить ход, 2 - показать карты, 3 - взять карту'
    end

    input = gets.chomp.to_i
    case input
    when 1
      @game.dealer_actions
    when 2
      @game.winner
    when 3
      @game.take_player_card
    else
      puts 'Неизвестная команда'
      user_actions
    end
  end
end