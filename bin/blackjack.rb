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
      return input.upcase
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

    @p1.display_hand
    @d1.display_one_card
    check_dealer_blackjack
    check_bust(@p1)

  end

  def entity_turn(entity)
    choice = entity.turn
    case choice
    when "H"
      hit(entity)
      check_bust(entity)
    else
      exit
    end
  end

  def deal_cards
    2.times do
      @p1.hand.push(@deck.deal)
      @p1.add_points
      @d1.hand.push(@deck.deal)
      @d1.add_points
    end
    ##Code to push specific cards
    # aces = @deck.cards.select do |obj|
    #   obj.rank == 11
    # end
    #
    # tens = @deck.cards.select do |obj|
    #   obj.rank == 10
    # end
    #  @d1.hand.push(aces.pop)
    #  @d1.add_points
    #  @d1.hand.push(tens.pop)
    #  @d1.add_points
    #  puts @d1.points
  end

  def check_dealer_blackjack
    if @d1.points == 21 && @d1.hand[0].rank == 11
      puts "Sorry Dealer Blackjack"
      game_end
    end
  end

  def hit(entity)
    puts "#{entity.name} hits"
    entity.hand.push(@deck.deal)
    entity.add_points
  end

  def check_bust(entity)
    if entity.points > 21
      puts "#{entity.name} has #{entity.points} points"
      puts "You bust!"
      game_end
    else
      puts "#{entity.name} has #{entity.points} points"
      entity_turn(entity)
    end
  end

  def game_end
    puts "good game!"
    exit
  end
end

game = Game.new
game.play
