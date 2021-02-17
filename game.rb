require_relative "player"
require_relative "bank"

class Game
  BASE_BET = 10

  def initialize
    # puts "Введите своё имя"
    # player_name = gets.chomp
    player_name = "mrkmx"

    @player = Player.new player_name
    @dealer = Player.new "Дилер"
    @bank = Bank.new
  end

  def start
    place_bets
  end

  def place_bets
    @player.money=(@player.money - BASE_BET)
    @dealer.money=(@dealer.money - BASE_BET)
    
    @bank.money=(@bank.money + (BASE_BET * 2))
  end
end
