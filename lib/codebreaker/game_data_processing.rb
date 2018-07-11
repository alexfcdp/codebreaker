module Codebreaker
  class GameDataProcessing
    include Codebreaker

    attr_reader :result_game

    def initialize(secret_code)
      @secret_code = secret_code
      @result_game = {}
      @result_matches = []
      @code_conversion = []
    end

    def check_matches(player_code)
      clear_data
      check_full_matches(player_code.split(''))
      complete_coincidence? ? @result_matches : check_any_matches
    end

    def check_full_matches(player_code)
      player_code.zip(@secret_code) do |gamer_code, privy_code|
        @result_matches << (gamer_code == privy_code ? EXACT_MATCH : gamer_code)
        @code_conversion << (gamer_code == privy_code ? -1 : privy_code)
      end
    end

    def check_any_matches
      @result_matches.map! do |item|
        if @code_conversion.include?(item)
          @code_conversion[@code_conversion.find_index(item)] = -1
          NUMERICAL_MATCH
        else
          item == EXACT_MATCH ? EXACT_MATCH : NO_MATCHES
        end
      end
    end

    def complete_coincidence?
      @result_matches.count(EXACT_MATCH) == SIZE_SECRET_CODE
    end

    def game_data(name, event, count_help, count_step)
      time = Time.now.strftime('%Y-%m-%d %H:%M')
      hint = "#{count_help}/#{COUNT_HINT}"
      steps = "#{count_step}/#{COUNT_MOVES}"
      @result_game = { 'Name' => name, 'Time' => time, 'Result' => event, 'Score' => score, \
                       'Hint' => hint, 'Steps' => steps, 'Secret code' => @secret_code.join }
    end

    private

    def score
      account = 0
      POINTS.each { |key, value| account += @result_matches.count(key) * value }
      account
    end

    def clear_data
      @result_matches.clear
      @code_conversion.clear
    end
  end
end
