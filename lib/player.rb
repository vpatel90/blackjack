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
