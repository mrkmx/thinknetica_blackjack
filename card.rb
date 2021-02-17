class Card
  attr_reader :score, :ace

  def initialize(name, score, ace)
    @name = name
    @score = score
    @ace = ace
  end
end
