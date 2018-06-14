module Codebreaker
  class View
    def initialize
      @game = Game.new
      @size = Game::SIZE_SECRET_CODE
      @result_game = ''
    end

    def load_game
      player_name
      print_info
      @game.start_game
      steps
      save_result
      plays_again
    end

    private

    def steps
      loop do
        return message_of_result('Game over!') if @game.loses_game?
        case @game.player_code = read_input
        when 'q' then exit
        when 'h' then show_hint
        else break if guessed?
        end
      end
    end

    def player_name
      print 'Enter your name: '
      name = read_input.capitalize
      @name_player = name == '' ? 'player' : name
    end

    def print_info
      puts "Welcome '#{@name_player}' to the game called codebreaker"
      puts "To exit the game enter 'q' and press enter"
      puts "To use hint, type 'h' and press enter"
    end

    def guessed?
      if @game.valid?
        puts "result: #{@game.guess}"
        return false unless @game.win?
        message_of_result('Win!')
        true
      else
        puts "Enter the code from #{@size} numbers from 1 to 6"
      end
    end

    def save_result
      puts 'Do you want to save the result y/n?'
      return unless confirm?
      @game.save_score(@name_player, @result_game)
      puts 'The result game saved!'
    end

    def plays_again
      puts 'Do you still want to play y/n?'
      confirm? ? load_game : exit
    end

    def confirm?
      case read_input
      when 'y' then true
      when 'n' then false
      else confirm?
      end
    end

    def show_hint
      help = @game.hint
      puts help.nil? ? 'All hints are exhausted' : help
    end

    def read_input
      gets.chomp.downcase
    end

    def message_of_result(event)
      puts @result_game = "#{event}\nSecret code: #{@game.instance_variable_get(:@secret_code)}\n" \
                          "You took steps #{@game.instance_variable_get(:@count_step)}/#{Game::COUNT_MOVES}"
    end
  end
end
