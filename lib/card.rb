class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit.to_s
    @value = value.to_s
  end

  def rank
    case @value
    when "K","Q","J" then @rank=10
    when "A" then @rank=11
    else
      @rank = @value.to_i
    end
  end
end
