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
