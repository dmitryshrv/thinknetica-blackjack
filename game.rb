class Game
  attr_accessor :player, :dealer, :deck, :round_bank

  def initialize
    @dealer = Dealer.new
    @deck = Deck.new
    @round_bank = 0
  end

  def start_game
    puts 'Ваше имя: '
    player_name = gets.chomp
    @player = Player.new(player_name)

    deal_cards(player)
    deal_cards(dealer)

    puts 'Сделана ставка $10'

    player.place_bet
    dealer.place_bet

    show_balance

    print 'Раздача (вы | дилер): '
    player.show_hand
    print '| '
    dealer.show_hidden
    puts ' ', player.points

    make_choice
    winner
    another_round?
  end

  def deal_cards(player)
    case player.hand.size
    when 0
      player.hand = 2.times.map { deck.cards.pop }
      black_jack?(player.count_points)
    when 2
      player.hand << deck.cards.pop
      player.count_points
    when 3
      'У вас 3 карты, больше добавить нельзя. Открываемся?'
    end
  end

  def show_balance
    puts "Ваш баланс #{player.bank} | Баланс дилера #{dealer.bank}"
    @round_bank = 20
    puts "В банке сейчас #{@round_bank}"
  end

  def make_choice
    puts ' '
    puts 'Ваше действие: '
    puts '1. Пропустить ход'
    puts '2. Взять карту'
    puts '3. Открыться'
    print '>'

    choice = gets.to_i

    case choice
    when 1
      dealer_turn
    when 2
      deal_cards(player)
      player.show_hand
      dealer_turn
    when 3
      open_cards
    end
  end

  def show_points
  end

  def dealer_turn
    points = @dealer.points

    if points == 21 && @player.points < 21
      puts 'Black Jack, дилер победил'
    elsif points >= 17
      puts 'Дилер сделал ход, ваша очередь'
      open_cards
    elsif points < 17
      puts 'Дилер берет карту'
      deal_cards(dealer)
      puts "У дилера перебор #{dealer.points}, вы победили!" if dealer.busted?
      open_cards
    end
  end

  def black_jack?(sum)
    sum == 21
  end

  def open_cards
    player.show_hand
    print "У вас #{@player.points} очков"
    puts ' '
    dealer.show_hand
    print " У дилера #{dealer.points}"
  end

  def winner
  end

  def another_round?
  end
end
