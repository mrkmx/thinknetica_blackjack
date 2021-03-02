# frozen_string_literal: true

require_relative 'player'
require_relative 'bank'
require_relative 'deck'

class Game
  attr_reader :player, :dealer, :users

  BASE_BET = 10
  MAX_CARDS = 3
  DEALER_THRESHOLD = 17
  GAME_GOAL = 21

  def initialize(player_name)
    @player = Player.new player_name
    @dealer = Player.new 'Дилер'
    @bank = Bank.new
    @users = [@player, @dealer]
  end

  def start
    @deck = Deck.new
    place_bets
    deal_cards
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

  def dealer_actions
    if @dealer.score >= DEALER_THRESHOLD
      nil
    else
      @dealer.take_card @deck
    end
  end

  def winner
    dealer_win || player_win || draw
  end

  def dealer_win
    return unless (@dealer.score <= GAME_GOAL && @dealer.score > @player.score) || @player.score > GAME_GOAL
    
    reward @dealer
    'dealer'
  end

  def player_win
    return unless (@player.score <= GAME_GOAL && @player.score > @dealer.score) || @dealer.score > GAME_GOAL
    
    reward @player
    'player'
  end

  def draw
    return unless @player.score == @dealer.score || (@player.score > GAME_GOAL && @dealer.score > GAME_GOAL)
    
    reward @player, @dealer
    'draw'
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

  def take_player_card
    @player.take_card @deck
  end

  def max_cards?(user)
    user.cards.length >= MAX_CARDS
  end

  def bankrupt?(user)
    user.money < BASE_BET
  end

  def over?
    @users.all? { |user| bankrupt?(user) || max_cards?(user) }
  end
end
