class Deck
  attr_reader :cards

  def initialize(epic=false)
    @cards = []
    suits = [:hearts, :diamonds, :spades, :clubs]
    suits.each do |suit|
      (2..10).each do |value|
        @cards << Card.new(suit, value)
      end
      @cards << Card.new(suit, "J")
      @cards << Card.new(suit, "Q")
      @cards << Card.new(suit, "K")
      @cards << Card.new(suit, "A")
    end
    @cards = @cards * 6 if epic == true
  end

  def shuffle_deck
    @cards.shuffle!
  end

  def deal
    @cards.shift
  end

end
