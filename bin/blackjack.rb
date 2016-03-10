require_relative '../lib/card'
require_relative '../lib/deck'
require_relative '../lib/player'
require_relative '../lib/dealer'
require_relative '../lib/renderer'
require_relative '../lib/game_play'

class Game
  def initialize(epic=false)
    @deck = Deck.new(epic)
    @deck.shuffle_deck
    @p1 = Player.new
    @d1 = Dealer.new
    @renderer = Renderer.new(@p1,@d1)

  end

  def start_round
    new_round = GamePlay.new(@p1, @d1, @renderer)
    winner = new_round.start_round(@deck)
    play_again
  end

  # def play
  #   @p1.reset
  #   @d1.reset
  #   @renderer = Renderer.new(@p1,@d1)
  #   deal_cards
  #
  #   @renderer.render_title
  #   @renderer.render_dealer_card
  #   check_blackjack(@p1)
  #   check_blackjack(@d1, true)
  #   check_bust(@p1)
  # end
  #
  # def entity_turn(entity)
  #   @renderer.render_title
  #   @renderer.render_dealer_card
  #   @renderer.display_last_move
  #   choice = entity.turn
  #   case choice
  #   when "H"
  #     hit(entity)
  #     puts entity.points
  #     check_bust(entity)
  #   when "S"
  #     stay(entity)
  #   when :d_stay
  #     entity.dealer_stays
  #     point_check
  #   else
  #     exit
  #   end
  # end
  #
  # def deal_cards
  #   2.times do
  #     @p1.hand.push(@deck.deal)
  #     @p1.add_points
  #     @d1.hand.push(@deck.deal)
  #     @d1.add_points
  #   end
  # end
  #
  # def check_blackjack(entity, dealer = false)
  #   if dealer == false
  #     if entity.points == 21
  #       @renderer.render_last_move(entity, "has Blackjack")
  #       point_check
  #     end
  #   elsif entity.points == 21 && entity.hand[0].set_rank == 11
  #       @renderer.render_last_move(entity, "has Blackjack")
  #       point_check
  #   end
  # end
  #
  # def hit(entity)
  #   @renderer.render_last_move(entity, "hits")
  #   entity.hand.push(@deck.deal)
  #   entity.add_points
  # end
  #
  # def stay(entity)
  #   @renderer.render_last_move(entity, "stays")
  #   check_bust(@d1)
  # end
  #
  # def check_bust(entity)
  #   @renderer.render_title
  #   if entity.name == "Dealer"
  #     @renderer.render_all_dealer_cards
  #     @renderer.display_last_move
  #   else
  #     @renderer.render_dealer_card
  #     @renderer.display_last_move
  #   end
  #   if entity.points > 21
  #     if entity.num_aces > 0
  #       entity.num_aces -= 1
  #       entity.points -=10
  #       entity_turn(entity)
  #     else
  #       #puts "#{entity.name} has #{entity.points} points"
  #       @renderer.render_last_move(entity, "busts!")
  #       winner = @p1.player_win_check(entity)
  #       game_end(winner)
  #     end
  #   else
  #     entity_turn(entity)
  #   end
  # end
  #
  # def point_check
  #   #puts "#{@p1.name} has #{@p1.points} points"
  #   #puts "#{@d1.name} has #{@d1.points} points"
  #   if @p1.points > @d1.points
  #     winner = @p1.name
  #   elsif @p1.points < @d1.points
  #     winner = @d1.name
  #   else
  #     puts "It's a tie"
  #     winner = "No one"
  #   end
  #   game_end(winner)
  # end
  #
  # def game_end(winner)
  #   @renderer.render_title
  #   @renderer.render_all_dealer_cards
  #   @renderer.display_last_move
  #   add_score(winner)
  #   puts
  #   puts "-"*30
  #   puts "#{winner} wins!"
  #   puts "Good Game!"
  #   puts "-"*30
  #   play_again
  # end

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
