require_relative './lib/card'
require_relative './lib/deck'
require_relative './lib/player'
require_relative './lib/dealer'
require_relative 'game'

game = Game.new
game.start_game
