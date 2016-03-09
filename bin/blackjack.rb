require_relative '../lib/card'
require_relative '../lib/deck'

class Player

  #has a turn
  attr_accessor :name, :hand
  def initialize(name = 'Player')
    @name = name
    @hand = []
  end

  def display_hand
    @hand.each do |card|
      puts "#{card.value} of #{card.suit}"
    end
  end


end

class Dealer
  attr_accessor :hand
  def initialize
    @hand = []
  end

  def display_one_card
    puts "#{@hand[0].value} of #{@hand[0].suit}"
  end

end
class Game
  def initialize
    @deck = Deck.new
    @deck.shuffle_deck
  end

  def play
    p1 = Player.new
    d1 = Dealer.new

    2.times do
      p1.hand.push(@deck.deal)
      d1.hand.push(@deck.deal)
    end

    p1.display_hand
    d1.display_one_card
  end

end

game = Game.new
game.play
