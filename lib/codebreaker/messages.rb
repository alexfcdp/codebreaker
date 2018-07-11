module Codebreaker
  class Messages
    include Codebreaker

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
      puts NO_HINT
    end

    def guessing_result(output)
      puts "result: #{output}"
    end

    def invalid_code
      puts INPUT_CONDITION
    end

    def show_result_game(output)
      puts DELIMITER
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
      puts "You have #{count}/#{COUNT_MOVES} attempts"
    end

    def view_games_history
      puts 'Want to see the result of games y/n?'
    end

    def publish_games_history(history_game)
      return puts 'The file is missing or corrupted' unless history_game
      history_game.each do |result|
        result.each { |key, value| puts "#{key}: #{value}" }
        puts DELIMITER
      end
    end
  end
end
