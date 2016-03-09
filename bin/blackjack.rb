require_relative '../lib/card'
require_relative '../lib/deck'

class Player
  attr_accessor :name, :hand, :points
  def initialize(name = 'Player')
    @name = name
    @hand = []
    @points = 0
  end

  def display_hand
    @hand.each do |card|
      puts "Player > #{card.value} of #{card.suit}"
    end
  end

  def add_points
    @points += @hand.last.rank
  end

  def turn
    puts "Would you like to (H)it or (S)tay"
    print " > "
    input = validate(gets.chomp)
  end

  def validate(input)
    case input.upcase
    when "H", "S"
    else
      puts "Enter Valid input"
      turn
    end
  end

end

class Dealer
  attr_accessor :hand, :points
  def initialize
    @hand = []
    @points = 0
  end

  def display_one_card
    puts "Dealer > #{@hand[0].value} of #{@hand[0].suit}"
    puts "Dealer > #{@hand[1].value} of #{@hand[1].suit}" ##Remove later
  end

  def add_points
    @points += @hand.last.rank
  end


end

class Game
  def initialize
    @deck = Deck.new
    @deck.shuffle_deck
  end

  def play
    @p1 = Player.new
    @d1 = Dealer.new
    deal_cards
    check_dealer_blackjack

    @p1.turn

    @p1.display_hand
    puts @p1.points
    @d1.display_one_card
    puts @d1.points


  end

  def deal_cards
    2.times do
      @p1.hand.push(@deck.deal)
      @p1.add_points
      @d1.hand.push(@deck.deal)
      @d1.add_points
    end
  end

  def check_dealer_blackjack
    game_end if @d1.points == 21
  end

  def hit(player)
    puts "#{player.name} hits"
    player.hand.push(@deck.deal)
    player.add_points
  end

  def game_end
    puts "good game!"
    exit
  end
end

game = Game.new
game.play
