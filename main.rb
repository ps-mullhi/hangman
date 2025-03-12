require_relative "lib/game_logic.rb"
require_relative "lib/alphabet.rb"
require 'json'


def welcome_message()
  puts('Welcome to Hangman!')
  puts('You will have 7 lives in order to guess the secret word.')
  puts('You may either guess a letter, or attempt to guess the entire word.')
  puts('Guessing incorrectly will cost 1 life.')
  puts('You may also choose to save the game.')
  puts('Good Luck!')
  puts("\n==================================\n\n")
end

def display_current_state(word_progress, remaining_letters)
  puts("Current progress: #{word_progress.join()}")
  puts("Remaining letters: #{remaining_letters}")
end

def get_user_option()
  puts('Would you like to:')
  puts("1. Guess a letter\n2. Guess the word\n3. Save the game")
  print('Enter either 1, 2, or 3: ')

  option = ""

  loop do
    option = gets.gsub(/\s+/, "") #remove whitespace
    is_option_valid = ["1", "2", "3"].include?(option)

    break if is_option_valid

    puts("Invalid option choice. Enter 1, 2, or 3.")
  end

  option
end

def get_letter_from_user()
  letter = ""
  
  loop do
    print("Enter your letter: ")
    letter = gets.gsub(/\s+/, "").downcase
    is_letter_valid = letter.match?(/\A[a-z]*\z/) && letter.length == 1

    unless is_letter_valid
      puts("Invalid letter.")
      next
    end

    print("Confirm your letter is \'#{letter}\'? (y/n): ")
    confirmation = gets.gsub(/\s+/, "").downcase
    break if confirmation == 'y'
  end

  letter
end

def get_word_from_user()
  word = ""

  loop do
    print("Enter your word: ")
    word = gets.gsub(/\s+/, "").downcase

    print("Confirm your word is \'#{word}\'? (y/n): ")
    confirmation = gets.gsub(/\s+/, "").downcase
    break if confirmation == 'y'
  end

  word
end

def process_letter_guess(game_logic, alphabet)
  letter = ""
  loop do
    letter = get_letter_from_user()

    break if alphabet.remaining_letters.include?(letter)

    puts 'You already guessed that.'
  end

  alphabet.remove_letter(letter)
  game_logic.update_word_progress(letter)
end

def process_word_guess(game_logic, alphabet)
  word = ""
  loop do
    word = get_word_from_user()

    break if game_logic.word.length == word.length

    puts 'Enter a word of the correct length.'
  end

  game_logic.user_guess_word(word)
end

def save_game(game_logic, alphabet)
  filename = "saved_data.json"

  save_data = JSON.dump ({
    :game_logic => game_logic.to_json(),
    :alphabet => alphabet.to_json()
  })

  File.open(filename, 'w') do |file|
    file.puts save_data
  end
end

def ask_load_game?()
  confirmation = ''
  loop do
    print('Would you like to load the last saved game (y/n): ')
    confirmation = gets.gsub(/\s+/, "").downcase
    break if confirmation == 'y' || confirmation == 'n'
  end
  
  if confirmation == 'y'
    true
  else
    false
  end
end

def load_saved_game()
  json_string = File.read('saved_data.json')

  data = JSON.load json_string
  game_logic_json = data['game_logic']
  alphabet_json = data['alphabet']

  restored_game_logic = GameLogic.from_json(game_logic_json)
  restored_alphabet = Alphabet.from_json(alphabet_json)

  [restored_game_logic, restored_alphabet]
end

def main()
  welcome_message()
  game_logic = nil
  alphabet = nil
  

  should_load = ask_load_game?()
  if should_load
    game_logic, alphabet = load_saved_game()
  else
    game_logic = GameLogic.new("dictionary.txt")
    alphabet = Alphabet.new()
  end


  loop do 
    display_current_state(game_logic.word_progress, alphabet.remaining_letters)
    option = get_user_option()

    if option == "1"
      process_letter_guess(game_logic, alphabet)
    elsif option == "2"
      process_word_guess(game_logic, alphabet)
    elsif option == "3"
      save_game(game_logic, alphabet)
      return
    else
      puts("You should never see this.")
    end

    break if (game_logic.word == game_logic.word_progress.join('')) || game_logic.number_of_lives == 0

    puts("\n\nLives left: #{game_logic.number_of_lives}")
  end

  puts("\n\nThe word was: #{game_logic.word}")
  if game_logic.number_of_lives > 0
    puts("You win!")
  else
    puts("You lose!")
  end
end


main()