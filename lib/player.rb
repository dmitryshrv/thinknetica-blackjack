class Player
  attr_accessor :points, :bank, :hand, :name

  START_BANK = 100
  BET = 10

  def initialize(name)
    @name = name
    @points = 0
    @bank = START_BANK
    @hand = []
  end

  def show_hand
    hand.each do |card|
      print "#{card.rank}#{card.suite} "
    end
  end

  def place_bet
    @bank -= BET
  end

  def count_points
    @points = 0
    @hand.each { |card| @points += card.value }
  end

  def busted?
    @points > 21
  end
end
