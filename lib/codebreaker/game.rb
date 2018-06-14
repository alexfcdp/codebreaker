module Codebreaker
  class Game
    require 'yaml'
    SIZE_SECRET_CODE = 4
    COUNT_HINT = 1
    COUNT_MOVES = 5
    attr_accessor :player_code

    def initialize
      @secret_code = Array.new(SIZE_SECRET_CODE)
    end

    def start_game
      @secret_code.map! { rand(1..6).to_s }
      @player_code = ''
      @count_help = 0
      @count_step = 0
    end

    def hint
      @count_help += 1
      @secret_code.sample if @count_help <= COUNT_HINT
    end

    def valid?
      @player_code.match?(/^[1-6]{#{SIZE_SECRET_CODE}}$/)
    end

    def guess
      @count_step += 1
      @player_code = @player_code.split('')
      check_full_match
      check_any_matches unless win?
      @player_code
    end

    def save_score(name, output)
      path = File.expand_path('../../result.yml', __dir__)
      time = Time.now.strftime('%Y-%m-%d %H:%M')
      data = { 'Name' => name, 'Time' => time, 'Result' => output }
      File.open(path, 'a') { |file| file.puts(data.to_yaml) }
    end

    def win?
      @player_code.count('+') == SIZE_SECRET_CODE
    end

    def loses_game?
      @count_step >= COUNT_MOVES
    end

    private

    def check_full_match
      result = []
      @sec_code = []
      @player_code.zip(@secret_code) do |pl, sec|
        result << (pl == sec ? '+' : pl)
        @sec_code << (pl == sec ? -1 : sec)
      end
      @player_code = result
    end

    def check_any_matches
      @player_code.map.with_index do |item, index|
        if @sec_code.include?(item)
          @player_code[index] = '-'
          ind_sec_code = @sec_code.find_index(item)
          @sec_code[ind_sec_code] = -1
        elsif item != '+'
          @player_code[index] = ''
        end
      end
    end
  end
end
