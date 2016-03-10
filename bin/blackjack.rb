require_relative '../lib/card'
require_relative '../lib/deck'
require_relative '../lib/player'
require_relative '../lib/dealer'
require_relative '../lib/renderer'
require_relative '../lib/game_play'

class Game
  def initialize(epic=false)
    @epic=epic
    @deck = Deck.new(@epic)
    @deck.shuffle_deck
    @p1 = Player.new
    @d1 = Dealer.new
    @renderer = Renderer.new(@p1,@d1)
  end

  def start_round
    if @deck.cards.length < 20
      @deck=Deck.new(@epic)
    end
    new_round = GamePlay.new(@p1, @d1, @renderer)
    winner = new_round.start_round(@deck)
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
    play_again
  end

  def validate_input(input)
    case input.upcase
    when "P"
      start_round
    when "S"
      system"clear"
      puts "#{@p1.name} has #{@p1.wins} wins"
      puts "#{@d1.name} has #{@d1.wins} wins"
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
    game.start_round
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
