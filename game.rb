class Game
  attr_accessor :player, :dealer, :deck, :round_bank

  def initialize
    @dealer = Dealer.new
    @deck = Deck.new
    @round_bank = 0
    @skip = false
  end

  def start_game
    puts 'Ваше имя: '
    player_name = gets.chomp
    @player = Player.new(player_name)

    loop do
      check_balance
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
      puts ' '

      make_choice
      winner
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
    @skip = false
    puts ' '
    puts 'Ваше действие: '
    puts '1. Пропустить ход'
    puts '2. Взять карту'
    puts '3. Открыться'
    print '>'

    choice = gets.to_i

    case choice
    when 1
      @skip = true
      dealer_turn
    when 2
      deal_cards(player)
      return if player.busted?

      dealer_turn
    when 3
      open_cards
    end
  end

  def dealer_turn
    points = dealer.points

    if points >= 17
      puts 'Дилер сделал ход'
      player_turn if @skip
    elsif points < 17
      puts 'Дилер берет карту'
      deal_cards(dealer)
      return if dealer.busted?

      player_turn if @skip
      open_cards
    end
  end

  def player_turn
    puts ' '
    puts 'Ваше действие: '
    puts '1. Взять карту'
    puts '2. Открыться'
    print '>'

    choice = gets.to_i

    case choice
    when 1
      deal_cards(player)
      return if player.busted?

      open_cards
    when 2
      open_cards
    end
  end

  def open_cards
    player.show_hand
    print "У вас #{@player.points} очков"
    puts ' '
    dealer.show_hand
    print " У дилера #{dealer.points}"
  end

  def winner
    puts ' '

    if player.busted?
      player.show_hand
      puts ' '
      @dealer.bank += round_bank
      puts 'У вас перебор. Дилер победил'
      puts "Ваш баланс: #{player.bank}"
      return
    elsif dealer.busted?
      dealer.show_hand
      puts ' '
      @player.bank += round_bank
      puts 'У дилера перебор. Вы победили'
      puts "Ваш баланс: #{player.bank}"
      return
    end

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

  def check_balance
    if @player.bank <= 0
      puts 'У вас кончились деньги. Игра закончена'
      exit
    elsif @dealer.bank <= 0
      puts 'У дилера кончились деньги. Игра закончена'
      exit
    end
  end
end
