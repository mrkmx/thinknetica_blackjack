# frozen_string_literal: true

class Card
  attr_reader :score, :ace, :name

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[♣ ♦ ♥ ♠].freeze

  def initialize(name, score, ace)
    @name = name
    @score = score
    @ace = ace
  end
end
