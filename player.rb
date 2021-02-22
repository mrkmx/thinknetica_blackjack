class Player
  attr_accessor :money
  attr_reader :name, :score, :cards

  def initialize(name)
    @name = name
    @cards = []
    @money = 100
    @score = 0
  end

  def take_card deck
    card = deck.cards.sample
    deck.cards.delete card

    @cards << card
    add_score card
  end

  def add_score card
    if card.ace && card.score + @score > 21
      @score += 1
    else
      @score += card.score
    end
  end

  def card_names
    @cards.each {|card| print "#{card.name} "}
  end

  def card_hidden_names
    @cards.each {|card| print "** "}
  end
end
