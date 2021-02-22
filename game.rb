# frozen_string_literal: true

require_relative 'player'
require_relative 'bank'
require_relative 'deck'

class Game
  BASE_BET = 10
  MAX_CARDS = 3
  DEALER_THRESHOLD = 17
  GAME_GOAL = 21

  def initialize
    puts "Введите своё имя"
    player_name = gets.chomp

    @player = Player.new player_name
    @dealer = Player.new 'Дилер'
    @bank = Bank.new
    @users = [@player, @dealer]
  end

  def start
    @deck = Deck.new
    place_bets
    deal_cards
    output
  end

  def continue
    over?
    puts 'Продолжить? (y/n)'
    input = gets.chomp
    if input == 'y'
      @users.each do |user|
        user.remove_cards
        user.remove_score
      end
      start
    elsif input == 'n'
      puts 'Завершение игры'
      exit
    else
      puts 'Неизвестная команда'
      continue
    end
  end

  def over?
    @users.each do |user|
      if user.money < BASE_BET
        puts "#{user.name} не может сделать ставку, игра окончена"
        exit
      end
    end
  end

  def place_bets
    @users.each do |user|
      user.money = (user.money - BASE_BET)
    end

    @bank.money = (@bank.money + (BASE_BET * 2))
  end

  def deal_cards
    @users.each do |user|
      2.times { user.take_card @deck }
    end
  end

  def output
    status
    user_actions
  end

  def status
    puts '========================='
    puts "#{@player.name}: #{@player.card_names}"
    puts "Очки: #{@player.score}, Деньги: #{@player.money}"
    puts '========================='
    puts "#{@dealer.name}: #{@dealer.card_hidden_names}"
    puts "Деньги: #{@dealer.money}"
    puts '========================='
  end

  def dealer_actions
    puts '========================='
    if @dealer.score >= DEALER_THRESHOLD
      puts 'Дилер пропускает ход'
      winner if @dealer.score >= GAME_GOAL
    else
      puts 'Дилер берет карту'
      @dealer.take_card @deck
      winner if max_cards? @dealer
    end
    output
    puts '========================='
  end

  def winner
    dealer_win
    player_win
    draw
    continue
  end

  def dealer_win
    return unless (@dealer.score <= GAME_GOAL && @dealer.score > @player.score) || @player.score > GAME_GOAL

    puts "Победил #{@dealer.name}"
    puts "#{@dealer.name}: #{@dealer.score}, #{@dealer.card_names}"
    puts "#{@player.name}: #{@player.score}, #{@player.card_names}"
    reward @dealer
  end

  def player_win
    return unless (@player.score <= GAME_GOAL && @player.score > @dealer.score) || @dealer.score > GAME_GOAL

    puts "Победил #{@player.name}"
    puts "#{@player.name}: #{@player.score}, #{@player.card_names}"
    puts "#{@dealer.name}: #{@dealer.score}, #{@dealer.card_names}"
    reward @player
  end

  def draw
    return unless @player.score == @dealer.score

    puts 'Ничья'
    puts "#{@player.name}: #{@player.score}, #{@player.card_names}"
    puts "#{@dealer.name}: #{@dealer.score}, #{@dealer.card_names}"
    reward @player, @dealer
  end

  def reward(*user)
    if user.length > 1 # Ничья
      user.each do |u|
        u.money = (u.money + BASE_BET)
        @bank.money = 0
      end
    else # 1 победитель
      user[0].money = (user[0].money + @bank.money)
      @bank.money = 0
    end
  end

  def user_actions
    if max_cards? @player
      puts '1 - пропустить ход, 2 - показать карты'
    else
      puts '1 - пропустить ход, 2 - показать карты, 3 - взять карту'
    end

    input = gets.chomp.to_i
    case input
    when 1
      dealer_actions
    when 2
      winner
    when 3
      take_player_card
    else
      puts 'Неизвестная команда'
      user_actions
    end
  end

  def take_player_card
    begin
      raise 'Взято максимальное количество карт' if max_cards? @player
    rescue RuntimeError => e
      puts e.message
      user_actions
    end
    @player.take_card @deck
    winner if @player.score >= GAME_GOAL
    dealer_actions
  end

  def max_cards?(user)
    user.cards.length >= MAX_CARDS
  end
end
