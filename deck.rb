require_relative "card"

class Deck
  def initialize
    @cards =[]
    create
  end

  def create
    Card::RANKS.each do |rank|
      Card::SUITS.each do |suit|
        name = rank + suit
        card = Card.new name
        @cards << card
      end
    end
  end

end
