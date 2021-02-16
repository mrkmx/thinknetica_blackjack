class Player
  attr_accessor :money

  def initialize(name)
    @name = name
    @cards = []
    @money = 100
    @score = 0
  end

end
