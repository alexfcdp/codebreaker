require 'yaml'

module Codebreaker
  class Game
    include Codebreaker

    attr_accessor :player_code
    attr_reader :count_help, :count_step, :data_processing

    def initialize
      @secret_code = Array.new(SIZE_SECRET_CODE)
      @file_path = File.expand_path('../../result.yml', __dir__)
    end

    def start_game
      @secret_code.map! { rand(1..6).to_s }
      @data_processing = GameDataProcessing.new(@secret_code)
      @player_code = ''
      @count_help = 0
      @count_step = 0
    end

    def hint
      return if @count_help >= COUNT_HINT
      @count_help += 1
      @secret_code.sample
    end

    def valid?
      @player_code.match?(/^[1-6]{#{SIZE_SECRET_CODE}}$/)
    end

    def guess
      @count_step += 1
      @data_processing.check_matches(@player_code)
    end

    def save_score
      return unless @data_processing.result_game
      data = read_score || []
      data << @data_processing.result_game
      File.write(@file_path, data.to_yaml)
    end

    def read_score
      YAML.safe_load(File.read(@file_path)) if File.file?(@file_path)
    end

    def data_preparation(name)
      event = win? ? WON : LOST
      @data_processing.game_data(name, event, @count_help, @count_step)
    end

    def win?
      @data_processing.complete_coincidence?
    end

    def loses_game?
      @count_step >= COUNT_MOVES
    end
  end
end
