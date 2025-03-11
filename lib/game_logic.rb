class GameLogic
  attr_reader :word, :word_progress

  def initialize(dictionary_filename)
    @word = choose_secret_word(dictionary_filename)
    @word_progress = setup_word_progress
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