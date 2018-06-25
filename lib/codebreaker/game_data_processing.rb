module Codebreaker
  class GameDataProcessing
    attr_accessor :gamer_code
    attr_reader :result_game
    def initialize(secret_code)
      @confidential_code = secret_code
      @result_game = {}
    end

    def check_full_match
      @guessed_code = []
      @result = []
      @gamer_code.zip(@confidential_code) do |pl, sec|
        @result << (pl == sec ? '+' : pl)
        @guessed_code << (pl == sec ? -1 : sec)
      end
      @result
    end

    def check_any_matches
      @result.map.with_index do |item, index|
        if @guessed_code.include?(item)
          @result[index] = '-'
          ind_sec_code = @guessed_code.find_index(item)
          @guessed_code[ind_sec_code] = -1
        elsif item != '+'
          @result[index] = ''
        end
      end
      @result
    end

    def game_data(name, event, count_help, count_step)
      time = Time.now.strftime('%Y-%m-%d %H:%M')
      used_hint = "#{count_help}/#{Game::COUNT_HINT}"
      took_steps = "#{count_step}/#{Game::COUNT_MOVES}"
      @result_game = { 'Name' => name, 'Time' => time, 'Result' => event, 'Score' => score, \
                       'Used hint' => used_hint, 'Took steps' => took_steps, 'Secret code' => @confidential_code.join }
    end

    private

    def score
      points = { '+' => 25, '-' => 15 }
      account = 0
      points.each { |key, value| account += @result.count(key) * value }
      account
    end
  end
end
