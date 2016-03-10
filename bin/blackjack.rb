require_relative '../lib/card'
require_relative '../lib/deck'

class Player
  attr_accessor :name, :hand, :points, :num_aces, :wins
  def initialize(name = 'Player')
    @num_aces = 0
    @name = name
    @hand = []
    @points = 0
    @wins = 0
  end

  def reset
    @num_aces =0
    @hand =[]
    @points =0
  end

  def display_hand
    @hand.each do |card|
      puts "Player > #{card.value} of #{card.suit}"
    end
  end

  def add_points
    @points += @hand.last.set_rank
    @num_aces += 1 if @hand.last.set_rank == 11
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
  attr_accessor :hand, :points, :name, :num_aces, :wins
  def initialize
    @name = "Dealer"
    @hand = []
    @points = 0
    @num_aces = 0
    @wins = 0
  end

  def reset
    @num_aces =0
    @hand =[]
    @points =0
  end

  def display_one_card
    puts "Dealer > #{@hand[0].value} of #{@hand[0].suit}"
  end

  def display_hand
    @hand.each do |card|
      puts "Dealer > #{card.value} of #{card.suit}"
    end
  end

  def add_points
    @points += @hand.last.set_rank
  end

  def turn
    if @points < 16
      puts "Dealer is thinking"
      sleep 1
      return "H"
    else
      sleep 1
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

class Renderer
  def initialize(player,dealer)
    @player = player
    @dealer = dealer
    @moves = []
  end

  def render_title
    system"clear"
    puts "BLACKJACK TIME!"
    puts "-"*30
    render_hands

  end

  def render_points
    puts "#{@player.name} has #{@player.points} points"
  end

  def render_hands
    @player.display_hand
    puts
    render_points
    puts
    puts "-"*30
  end

  def render_dealer_card
    puts @dealer.display_one_card
    puts "Dealer's second card is hidden"
    puts "-"*30
  end

  def render_all_dealer_cards
    @dealer.display_hand
    puts "-"*30
    puts
  end

  def render_last_move(entity, move)
    str = "#{entity.name} #{move}"
    @moves.push(str)
  end

  def display_last_move
    puts "-"*30
    if @moves.length > 3
      puts @moves.last(3)
    else
      puts @moves
    end
  end

  def render_score
    system"clear"
    puts "#{@player.name} has #{@player.wins} wins"
    puts "#{@dealer.name} has #{@dealer.wins} wins"
  end
end

class Game
  def initialize(epic=false)
    @deck = Deck.new(epic)
    @deck.shuffle_deck
    @p1 = Player.new
    @d1 = Dealer.new
  end

  def play
    @p1.reset
    @d1.reset
    @renderer = Renderer.new(@p1,@d1)
    deal_cards

    @renderer.render_title
    @renderer.render_dealer_card
    check_blackjack(@p1)
    check_blackjack(@d1, true)
    check_bust(@p1)
  end

  def entity_turn(entity)
    @renderer.render_title
    @renderer.render_dealer_card
    @renderer.display_last_move
    choice = entity.turn
    case choice
    when "H"
      hit(entity)
      puts entity.points
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
        @renderer.render_last_move(entity, "has Blackjack")
        point_check
      end
    elsif entity.points == 21 && entity.hand[0].set_rank == 11
        @renderer.render_last_move(entity, "has Blackjack")
        point_check
    end
  end

  def hit(entity)
    @renderer.render_last_move(entity, "hits")
    entity.hand.push(@deck.deal)
    entity.add_points
  end

  def stay(entity)
    @renderer.render_last_move(entity, "stays")
    check_bust(@d1)
  end

  def check_bust(entity)
    @renderer.render_title
    if entity.name == "Dealer"
      @renderer.render_all_dealer_cards
      @renderer.display_last_move
    else
      @renderer.render_dealer_card
      @renderer.display_last_move
    end
    if entity.points > 21
      if entity.num_aces > 0
        entity.num_aces -= 1
        entity.points -=10
        #puts "#{entity.name} has #{entity.points} points"
        entity_turn(entity)
      else
        #puts "#{entity.name} has #{entity.points} points"
        @renderer.render_last_move(entity, "busts!")
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
    add_score(winner)
    puts
    puts "-"*30
    puts "#{winner} wins!"
    puts "Good Game!"
    puts "-"*30
    play_again
  end

  def play_again
    puts "Want to (P)lay again, check (S)core or (Q)uit?"
    input = validate_input(gets.chomp)
  end

  def add_score(winner)
    case winner
    when @p1.name
      @p1.wins += 1
    when @d1.name
      @d1.wins += 1
    else
    end
  end

  def validate_input(input)
    case input.upcase
    when "P"
      play
    when "S"
      @renderer.render_score
      play_again
    when "Q"
      exit
    else
    end

  end
end

def validate(input)
  case input.upcase
  when "Y"
    game = Game.new(true)
    game.play
  when "N"
    game = Game.new
    game.play
  else
    puts "Enter a valid input"
    start
  end
end

def start
  system'clear'
  puts "Would you like to play epic mode (6 decks)?(Y) or (N)"
  input = validate(gets.chomp)
  game = Game.new
  game.play
end
start
