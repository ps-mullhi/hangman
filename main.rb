require_relative "lib/game_logic.rb"

game_logic = GameLogic.new("dictionary.txt")
puts game_logic.word
p game_logic.word_progress