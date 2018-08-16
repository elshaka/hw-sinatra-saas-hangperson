class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_reader :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(guess)
    raise ArgumentError if (guess.nil? || guess.empty? || !(guess =~ /\w/))
    guess.downcase!
    if valid = @word.include?(guess) && !@guesses.include?(guess)
      @guesses += guess
    else
      @wrong_guesses += guess unless @wrong_guesses.include?(guess)
    end
    valid
  end

  def word_with_guesses
    @word.gsub(/./) { |c| @guesses.include?(c) ? c : '-' }
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.size == 7
    return :win if @word == word_with_guesses
    return :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
