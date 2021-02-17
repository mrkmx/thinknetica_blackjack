class Player
  attr_accessor :money

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

end
