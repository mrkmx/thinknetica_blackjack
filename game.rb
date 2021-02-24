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

  def initialize(client, player_name)
    @client = client
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

  def over?
    @users.each do |user|
      if user.money < BASE_BET
        @client.output "#{user.name} не может сделать ставку, игра окончена"
        exit # ToDo: как это будет работать с другими интерфейсами, кроме терминала?
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
    @client.status
    @client.menu_user_actions
  end

  def dealer_actions
    @client.output '========================='
    if @dealer.score >= DEALER_THRESHOLD
      @client.output 'Дилер пропускает ход'
      winner if @dealer.score >= GAME_GOAL
    else
      @client.output 'Дилер берет карту'
      @dealer.take_card @deck
      winner if max_cards? @dealer
    end
    output
    @client.output '========================='
  end

  def winner
    dealer_win
    player_win
    draw
    @client.menu_continue
  end

  def dealer_win
    return unless (@dealer.score <= GAME_GOAL && @dealer.score > @player.score) || @player.score > GAME_GOAL

    @client.output "Победил #{@dealer.name}"
    @client.output "#{@dealer.name}: #{@dealer.score}, #{@dealer.card_names}"
    @client.output "#{@player.name}: #{@player.score}, #{@player.card_names}"
    reward @dealer
  end

  def player_win
    return unless (@player.score <= GAME_GOAL && @player.score > @dealer.score) || @dealer.score > GAME_GOAL

    @client.output "Победил #{@player.name}"
    @client.output "#{@player.name}: #{@player.score}, #{@player.card_names}"
    @client.output "#{@dealer.name}: #{@dealer.score}, #{@dealer.card_names}"
    reward @player
  end

  def draw
    return unless @player.score == @dealer.score

    @client.output 'Ничья'
    @client.output "#{@player.name}: #{@player.score}, #{@player.card_names}"
    @client.output "#{@dealer.name}: #{@dealer.score}, #{@dealer.card_names}"
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

  def take_player_card
    begin
      raise 'Взято максимальное количество карт' if max_cards? @player
    rescue RuntimeError => e
      @client.output e.message
      @client.menu_user_actions
    end
    @player.take_card @deck
    winner if @player.score >= GAME_GOAL
    dealer_actions
  end

  def max_cards?(user)
    user.cards.length >= MAX_CARDS
  end
end
