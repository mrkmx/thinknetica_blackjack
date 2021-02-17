require_relative "card"

class Deck
  attr_reader :cards

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[♣ ♦ ♥ ♠].freeze
  
  def initialize
    @cards = []
    create
  end

  def create
    RANKS.each do |rank|
      SUITS.each do |suit|
        name = rank + suit
        score = card_score rank
        ace = ace? rank

        card = Card.new name, score, ace
        @cards << card
      end
    end
  end

  def card_score rank
    return 10 if %w[J Q K].include? rank 
    return 11 if rank == "A"
    rank.to_i
  end

  def ace? rank
    rank == "A"
  end

end
