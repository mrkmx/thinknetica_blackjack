class Card
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[♣ ♦ ♥ ♠].freeze

  def initialize(name)
    @name = name
  end
end
