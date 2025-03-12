class Alphabet
  attr_reader :remaining_letters

  def initialize()
    @remaining_letters = [
      'a', 'b', 'c', 'd', 'e', 
      'f', 'g', 'h', 'i', 'j',
      'k', 'l', 'm', 'n', 'o',
      'p', 'q', 'r', 's', 't',
      'u', 'v', 'w', 'x', 'y',
      'z'
    ]
  end

  def remove_letter(letter)
    @remaining_letters = remaining_letters.map do |elem|
      if elem == letter
        elem = "_"
      else
        elem
      end
    end
  end
end