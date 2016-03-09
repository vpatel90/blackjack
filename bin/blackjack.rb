require_relative '../lib/card'
require_relative '../lib/deck'

class Game
  def initialize
    @deck = Deck.new
    @deck.shuffle_deck
  end

  def play
    card = @deck.deal
    puts card.value + card.suit
  end

end

game = Game.new
game.play
