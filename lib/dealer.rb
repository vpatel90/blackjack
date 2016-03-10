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
