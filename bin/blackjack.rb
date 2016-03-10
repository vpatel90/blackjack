require_relative '../lib/card'
require_relative '../lib/deck'

class Player
  attr_accessor :name, :hand, :points, :num_aces
  def initialize(name = 'Player')
    @num_aces = 0
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
    @points += @hand.last.set_rank
    @num_aces += 1 if @hand.last.set_rank == 11
    puts @points
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

  def player_win_check(entity)
    if entity.name != @name
      winner = entity
      return @name
    else
      return "Dealer"
    end
  end
end

class Dealer
  attr_accessor :hand, :points, :name, :num_aces
  def initialize
    @name = "Dealer"
    @hand = []
    @points = 0
    @num_aces = 0
  end

  def display_one_card
    puts "Dealer > #{@hand[0].value} of #{@hand[0].suit}"
    puts "Dealer > #{@hand[1].value} of #{@hand[1].suit}" ##Remove later
  end

  def add_points
    @points += @hand.last.set_rank
  end

  def turn
    if @points < 16
      puts "Dealer is thinking"
      sleep 0.5
      return "H"
    else
      return :d_stay
    end
  end

  def dealer_busts
    puts "Dealer Busts"
  end

  def dealer_stays
    puts "Dealer Stays"
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
    check_blackjack(@p1)
    check_blackjack(@d1, true)
    check_bust(@p1)
  end

  def entity_turn(entity)
    choice = entity.turn
    case choice
    when "H"
      hit(entity)
      check_bust(entity)
    when "S"
      stay(entity)
    when :d_stay
      entity.dealer_stays
      point_check
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
  end

  def check_blackjack(entity, dealer = false)
    if dealer == false
      if entity.points == 21
        puts "#{entity.name} has Blackjack"
        point_check
      end
    elsif entity.points == 21 && entity.hand[0].set_rank == 11
        puts "#{entity.name} has Blackjack"
        point_check
    end
  end

  def hit(entity)
    puts "#{entity.name} hits"
    entity.hand.push(@deck.deal)
    entity.add_points
  end

  def stay(entity)
    puts "#{entity.name} stays"
    check_bust(@d1)
  end

  def check_bust(entity)
    if entity.points > 21
      if entity.num_aces > 0
        entity.num_aces -= 1
        entity.points -=10
        #puts "#{entity.name} has #{entity.points} points"
        entity_turn(entity)
      else
        #puts "#{entity.name} has #{entity.points} points"
        puts "#{entity.name} busts!"
        winner = @p1.player_win_check(entity)
        game_end(winner)
      end
    else
      #puts "#{entity.name} has #{entity.points} points"
      entity_turn(entity)
    end
  end

  def point_check
    #puts "#{@p1.name} has #{@p1.points} points"
    #puts "#{@d1.name} has #{@d1.points} points"
    if @p1.points > @d1.points
      winner = @p1.name
    elsif @p1.points < @d1.points
      winner = @d1.name
    else
      puts "It's a tie"
      winner = "No one"
    end
    game_end(winner)
  end

  def game_end(winner)
    puts "#{winner} wins!"
    puts "good game!"
    exit
  end
end

game = Game.new
game.play
