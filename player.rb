# frozen_string_literal: true

class Player
  attr_accessor :money
  attr_reader :name, :score, :cards

  INIT_AMOUNT = 100
  GAME_GOAL = 21

  def initialize(name)
    @name = name
    @cards = []
    @money = INIT_AMOUNT
    @score = 0
  end

  def take_card(deck)
    card = deck.cards.sample
    deck.cards.delete card

    @cards << card
    add_score card
    card
  end

  def remove_cards
    @cards = []
  end

  def remove_score
    @score = 0
  end

  def add_score(card)
    @score += if card.ace && card.score + @score > GAME_GOAL
                1
              else
                card.score
              end
  end

  def card_names
    @cards.map(&:name).join(' ')
  end

  def card_masked_names
    @cards.map(&:name).join(' ').gsub(/\S/, '*')
  end
end
