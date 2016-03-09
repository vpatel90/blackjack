class Blackjack

end

class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit.to_s
    @value = value.to_s
  end
end

class Deck
  def initialize
    @deck = []
  end
  def make_deck
    suits = [:hearts, :diamonds, :spades, :clubs]
    suits.each do |suit|
      (2..10).each do |value|
        @deck << Card.new(suit, value)
      end
      @deck << Card.new(suit, "J")
      @deck << Card.new(suit, "Q")
      @deck << Card.new(suit, "K")
      @deck << Card.new(suit, "A")
    end
    @deck.each {|card| puts "#{card.value} of #{card.suit}"}
  end
end

deck = Deck.new
deck.make_deck
