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

  def to_json()
    JSON.dump ({
      :remaining_letters => @remaining_letters
    })
  end

  def self.from_json(string)
    data = JSON.load string
    obj = self.new()
    obj.instance_variable_set(:@remaining_letters, data['remaining_letters'])
    obj
  end
end