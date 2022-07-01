class Game
  attr_accessor :player, :dealer, :deck, :round_bank
  
  def initialize
    @dealer = Dealer.new
    @deck = Deck.new
    @round_bank = 0
    @busted = false
  end

  def start_game
    puts 'Ваше имя: '
    player_name = gets.chomp
    @player = Player.new(player_name)

    loop do
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
      puts ' ', @player.points

      make_choice
      winner unless @busted
      break unless another_round?

      prepare_new_round
    end
  end

  def deal_cards(player)
    case player.hand.size
    when 0
      player.hand = 2.times.map { deck.cards.pop }
      player.count_points
    when 2
      player.hand << deck.cards.pop
      player.count_points
      end_round_busted if player.busted? 
    when 3
      'У вас 3 карты, больше добавить нельзя. Открываемся?'
    end
  end

  def show_balance
    puts "Ваш баланс #{@player.bank} | Баланс дилера #{@dealer.bank}"
    @round_bank = @player.bet + @dealer.bet
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
      break if @busted
      dealer_turn
    when 3
      open_cards
    end
  end

  def dealer_turn
    points = dealer.points

    if points >= 17
      puts 'Дилер сделал ход, ваша очередь'
      #player_turn
      open_cards
    elsif points < 17
      puts 'Дилер берет карту'
      deal_cards(dealer)
      #puts "У дилера перебор #{dealer.points}, вы победили!" if dealer.busted?
      open_cards
      break if @busted
    end
  end

  def open_cards
    player.show_hand
    print "У вас #{@player.points} очков"
    puts ' '
    dealer.show_hand
    print " У дилера #{dealer.points}"
  end

  def end_round_busted
    @busted = true
    puts 'Перебор!'

  end

  def winner
    puts ' '
    if player.points > dealer.points
      puts 'Вы победили. Забирайте весь банк'
      @player.bank += round_bank
      puts "Ваш баланс: #{player.bank}"
    elsif player.points < dealer.points
      puts 'Дилер победил. Деньги уходят дилеру'
      @dealer.bank += round_bank
      puts "Ваш баланс: #{player.bank}"
    elsif player.points == dealer.points
      puts 'Ничья. Ставки делятся поровну'
      @player.bank += round_bank/2
      @dealer.bank += round_bank/2
      puts "Ваш баланс: #{player.bank}"
    end
  end

  def black_jack?(sum)
    sum == 21
  end

  def another_round?
    puts ' '
    print 'Еще раунд? [Y/N]: '
    choice = gets.chomp.upcase

    case choice
    when 'Y'
      true
    when 'N'
      false
    end
  end

  def prepare_new_round
    @player.hand = []
    @dealer.hand = []
    @deck = Deck.new
  end
end
