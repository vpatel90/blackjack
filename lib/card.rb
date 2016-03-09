class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit.to_s
    @value = value.to_s
  end
end
