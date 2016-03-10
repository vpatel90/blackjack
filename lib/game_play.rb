require_relative '../lib/player'
require_relative '../lib/dealer'
require_relative '../lib/renderer'
require_relative '../lib/player'


class GamePlay
  def initialize(player, dealer, renderer)
    @player = player
    @dealer = dealer
    @renderer = renderer
  end

  def start_round(deck)
    @player.reset
    @dealer.reset
    @renderer.reset
    @deck = deck
    deal_cards
    start_renderer
  end

  def deal_cards
    2.times do
      @player.hand.push(@deck.deal)
      @player.add_points
      @dealer.hand.push(@deck.deal)
      @dealer.add_points
    end
  end

  def start_renderer
    @renderer.render_title
    @renderer.render_dealer_card
    check_blackjack(@player)
    check_blackjack(@dealer, true)
  end

  def check_blackjack(entity, is_dealer = false)
    if is_dealer == false
      if entity.points == 21
        @renderer.render_last_move(entity, "has Blackjack")
        point_check
      else
        check_bust(entity)
      end
    elsif entity.points == 21 && entity.hand[0].set_rank == 11
        @renderer.render_last_move(entity, "has Blackjack")
        point_check
    end
  end

  def check_bust(entity)
    puts entity.class
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
        entity_turn(entity)
      else
        #puts "#{entity.name} has #{entity.points} points"
        @renderer.render_last_move(entity, "busts!")
        winner = @player.player_win_check(entity)
        game_end(winner)
      end
    else
      entity_turn(entity)
    end
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

  def hit(entity)
    @renderer.render_last_move(entity, "hits")
    entity.hand.push(@deck.deal)
    entity.add_points
  end

  def stay(entity)
    @renderer.render_last_move(entity, "stays")
    @renderer.render_title
    @renderer.render_all_dealer_cards
    check_bust(@dealer)
  end

  def point_check
    #puts "#{@p1.name} has #{@p1.points} points"
    #puts "#{@d1.name} has #{@d1.points} points"
    if @player.points > @dealer.points
      winner = @player.name
    elsif @player.points < @dealer.points
      winner = @dealer.name
    else
      puts "It's a tie"
      winner = "No one"
    end
    game_end(winner)
  end

  def game_end(winner)
    @renderer.render_title
    @renderer.render_all_dealer_cards
    @renderer.display_last_move
    puts
    puts "-"*30
    puts "#{winner} wins!"
    puts "Good Game!"
    puts "-"*30
    add_score(winner)
  end

  def add_score(winner)

    case winner
    when @player.name
      @player.wins += 1
    when @dealer.name
      @dealer.wins += 1
    else
    end
  end


end
