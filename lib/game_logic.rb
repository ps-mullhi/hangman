require 'json'

class GameLogic
  attr_reader :word, :word_progress, :number_of_lives

  def initialize(dictionary_filename)
    @word = choose_secret_word(dictionary_filename)
    @word_progress = setup_word_progress
    @number_of_lives = 7
  end

  def update_word_progress(letter)
    unless self.word.include?(letter)
      @number_of_lives -= 1
      return
    end

    word_as_array = self.word.split('')
    word_as_array.each_with_index do |char, i|
      if word_as_array[i] == letter
        @word_progress[i] = letter
      end
    end
  end

  def user_guess_word(word)
    if self.word == word
      @word_progress = self.word.split('')
    else
      @number_of_lives -= 1
    end
  end

  def to_json()
    JSON.dump ({
      :word => @word,
      :word_progress => @word_progress,
      :number_of_lives => @number_of_lives
    })
  end

  def self.from_json(string)
    data = JSON.load string
    obj = self.new('dictionary.txt')
    obj.instance_variable_set(:@word, data['word'])
    obj.instance_variable_set(:@word_progress, data['word_progress'])
    obj.instance_variable_set(:@number_of_lives, data['number_of_lives'])
    obj
  end

  private 

  def choose_secret_word(filename)
    unless File.exist?(filename)
      abort('Dictionary does not exist')
    end

    all_words = File.read('dictionary.txt')
    possible_words = all_words.split("\n").select do |word|
      word.length >= 5 && word.length <= 12
    end
    
    possible_words.sample
  end

  def setup_word_progress()
    word_length = self.word.length

    Array.new(word_length) {"_"}
  end
end