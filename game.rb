require_relative "player"
require_relative "bank"
require_relative "deck"

class Game
  BASE_BET = 10
  MAX_CARDS = 3
  DEALER_THRESHOLD = 17

  def initialize
    # puts "Введите своё имя"
    # player_name = gets.chomp
    player_name = "mrkmx"

    @player = Player.new player_name
    @dealer = Player.new "Дилер"
    @bank = Bank.new
    @deck = Deck.new
  end

  def start
    place_bets
    deal_cards
    output
  end

  def place_bets
    @player.money=(@player.money - BASE_BET)
    @dealer.money=(@dealer.money - BASE_BET)
    
    @bank.money=(@bank.money + (BASE_BET * 2))
  end

  def deal_cards
    2.times { @player.take_card @deck }
    2.times { @dealer.take_card @deck }
  end

  def output
    status
    user_actions
  end

  def status
    puts "========================="
    puts "#{@player.name}: #{@player.card_names}"
    puts "Очки: #{@player.score}, Деньги: #{@player.money}"
    puts "========================="
    puts "#{@dealer.name}: #{@dealer.card_hidden_names}"
    puts "Деньги: #{@dealer.money}"
    puts "========================="
  end

  def dealer_actions
    if @dealer.score >= DEALER_THRESHOLD
      puts "========================="
      puts "Дилер пропускает ход"
      puts "========================="
      output
    else
      puts "========================="
      puts "Дилер берет карту"
      puts "========================="
      @dealer.take_card @deck
      output
    end
  end

  def winner
    
  end

  def user_actions
    unless max_cards? @player
      puts "1 - пропустить ход, 2 - показать карты, 3 - взять карту"
    else
      puts "1 - пропустить ход, 2 - показать карты"
    end
    
    input = gets.chomp.to_i
    case input
      when 1
        dealer_actions
      when 2
        winner
      when 3
        begin
          raise "Взято максимальное количество карт" if max_cards? @player
        rescue RuntimeError => e
          puts e.message
          user_actions
        end
        @player.take_card @deck
        dealer_actions
      else
        puts "Неизвестная команда"
        user_actions
      end
  end

  def max_cards? user
    user.cards.length >= MAX_CARDS
  end
end
