module Codebreaker
  class Messages
    def enter_name
      print 'Enter your name: '
    end

    def print_info(name)
      puts "Welcome '#{name}' to the game called codebreaker\n" \
           "To exit the game enter 'q' and press enter\n" \
           "To use hint, type 'h' and press enter"
    end

    def give_hint(help)
      puts help
    end

    def no_hint
      puts 'All hints are exhausted'
    end

    def guessing_result(output)
      puts "result: #{output}"
    end

    def invalid_code
      puts "Enter the code from #{Game::SIZE_SECRET_CODE} numbers from 1 to 6"
    end

    def show_result_game(output)
      puts('*' * 40).to_s
      output.each { |key, value| puts "#{key}: #{value}" }
    end

    def save_game
      puts 'Do you want to save the result y/n?'
    end

    def game_saved
      puts 'The result game saved!'
    end

    def return_game
      puts 'Do you still want to play y/n?'
    end

    def show_number_attempts(count)
      puts "You have #{count}/#{Game::COUNT_MOVES} attempts"
    end

    def view_games_history
      puts 'Want to see the result of games y/n?'
    end

    def publish_games_history(history_game)
      if history_game.nil? then puts 'The file is missing or corrupted'
      else
        history_game.each do |result|
          result.each { |key, value| puts "#{key}: #{value}" }
          puts('-' * 40).to_s
        end
      end
    end
  end
end
