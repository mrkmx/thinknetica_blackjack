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
  end

end
