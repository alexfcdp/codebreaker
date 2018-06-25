module Codebreaker
  class View
    PLAYER_NAME = 'Player'.freeze
    def initialize
      @messages = Messages.new
      @game = Game.new
      @moves_count = Game::COUNT_MOVES
      view_result_games
    end

    def load_game
      player_name
      @messages.print_info(@name_player)
      @game.start_game
      steps
      @game.data_preparation(@name_player)
      message_of_result
      save_result
      view_result_games
      plays_again
    end

    private

    def steps
      loop do
        break if @game.loses_game?
        case @game.player_code = read_input
        when 'q' then exit
        when 'h' then show_hint
        else break if guessed?
        end
      end
    end

    def player_name
      @messages.enter_name
      @name_player = read_input.capitalize
      @name_player = PLAYER_NAME if @name_player == ''
    end

    def guessed?
      if @game.valid?
        @messages.guessing_result(@game.guess)
        remained_attempts_count
        return true if @game.win?
      else
        @messages.invalid_code
      end
      false
    end

    def save_result
      @messages.save_game
      return unless confirm?
      @game.save_score
      @messages.game_saved
    end

    def plays_again
      @messages.return_game
      confirm? ? load_game : exit
    end

    def view_result_games
      @messages.view_games_history
      @messages.publish_games_history(@game.read_score) if confirm?
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
      help.nil? ? @messages.no_hint : @messages.give_hint(help)
    end

    def read_input
      gets.chomp.downcase
    end

    def message_of_result
      @messages.show_result_game(@game.data_processing.result_game)
    end

    def remained_attempts_count
      attempts_count = @moves_count - @game.count_step
      @messages.show_number_attempts(attempts_count) unless attempts_count.zero? || @game.win?
    end
  end
end
