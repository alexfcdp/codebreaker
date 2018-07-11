require_relative '../spec_helper'
require 'simplecov'
SimpleCov.start

module Codebreaker
  RSpec.describe Game do
    let(:game) { Game.new }
    let(:data_processing) { game.data_processing }

    before do
      game.start_game
      @size = Game::SIZE_SECRET_CODE
    end

    describe '#start_game' do
      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code).join).to match(/^[1-6]{#{@size}}$/)
      end

      it 'when you start a new game, a new secret code is generated' do
        previous_code = game.instance_variable_get(:@secret_code).join
        game.start_game
        expect(game.instance_variable_get(:@secret_code).join).to_not eq(previous_code)
      end

      it 'resets the hint count to zero when the game starts' do
        expect(game.instance_variable_get(:@count_help)).to eq(0)
      end

      it 'resets the step count to zero when the game starts' do
        expect(game.instance_variable_get(:@count_step)).to eq(0)
      end
      it 'discards the players code when the game starts' do
        expect(game.instance_variable_get(:@player_code)).to eq('')
      end
      it 'transfers a secret code to the GameDataProcessing' do
        secret_code = game.instance_variable_get(:@secret_code)
        confidential_code = data_processing.instance_variable_get(:@secret_code)
        expect(secret_code).to eq(confidential_code)
      end
    end

    describe '#hint' do
      it 'return a random digit from the secret code' do
        expect(game.hint).to match(/^[1-6]{1}$/)
      end

      it 'checks there is this random digit in the secret code' do
        expect(game.instance_variable_get(:@secret_code)).to include(game.hint)
      end

      it 'outputs a message when the hints is complete' do
        count = Game::COUNT_HINT + 1
        game.instance_variable_set(:@count_help, count)
        expect(game.hint).to be_nil
      end
    end

    describe '#valid?' do
      it 'returns true if the code is valid' do
        game.player_code = '3452'
        expect(game.valid?).to be true
      end
      it 'returns false if the code is not valid' do
        game.player_code = '3725'
        expect(game.valid?).to be false
      end
    end

    describe '#guess' do
      context 'get results when the player enters any code' do
        codes = [
          { secret_code: %w[2 4 2 6], player_code: '2426', result: %w[+ + + +] },
          { secret_code: %w[1 1 1 1], player_code: '1111', result: %w[+ + + +] },
          { secret_code: %w[2 5 3 5], player_code: '2535', result: %w[+ + + +] },
          { secret_code: %w[2 2 6 6], player_code: '6622', result: %w[- - - -] },
          { secret_code: %w[6 5 4 3], player_code: '3456', result: %w[- - - -] },
          { secret_code: %w[2 2 3 4], player_code: '3422', result: %w[- - - -] },
          { secret_code: %w[1 1 2 3], player_code: '2311', result: %w[- - - -] },
          { secret_code: %w[2 3 3 3], player_code: '3332', result: %w[- + + -] },
          { secret_code: %w[5 4 2 3], player_code: '5243', result: %w[+ - - +] },
          { secret_code: %w[4 4 1 2], player_code: '4142', result: %w[+ - - +] },
          { secret_code: %w[1 6 5 5], player_code: '5615', result: %w[- + - +] },
          { secret_code: %w[3 3 1 2], player_code: '3321', result: %w[+ + - -] },
          { secret_code: %w[4 2 2 4], player_code: '2424', result: %w[- - + +] },
          { secret_code: %w[6 5 1 2], player_code: '6215', result: %w[+ - + -] },
          { secret_code: %w[6 6 2 6], player_code: '6646', result: ['+', '+', '', '+'] },
          { secret_code: %w[2 3 3 2], player_code: '5322', result: ['', '+', '-', '+'] },
          { secret_code: %w[1 6 6 4], player_code: '6465', result: ['-', '-', '+', ''] },
          { secret_code: %w[2 5 3 1], player_code: '2365', result: ['+', '-', '', '-'] },
          { secret_code: %w[5 4 4 1], player_code: '6445', result: ['', '+', '+', '-'] },
          { secret_code: %w[3 3 1 5], player_code: '5413', result: ['-', '', '+', '-'] },
          { secret_code: %w[6 6 2 6], player_code: '6263', result: ['+', '-', '-', ''] },
          { secret_code: %w[2 3 3 2], player_code: '3332', result: ['', '+', '+', '+'] },
          { secret_code: %w[5 4 2 3], player_code: '1543', result: ['', '-', '-', '+'] },
          { secret_code: %w[2 2 6 6], player_code: '3242', result: ['', '+', '', '-'] },
          { secret_code: %w[5 5 5 3], player_code: '5434', result: ['+', '', '-', ''] },
          { secret_code: %w[3 6 6 3], player_code: '1332', result: ['', '-', '-', ''] },
          { secret_code: %w[5 4 1 1], player_code: '2314', result: ['', '', '+', '-'] },
          { secret_code: %w[2 3 3 3], player_code: '3443', result: ['-', '', '', '+'] },
          { secret_code: %w[3 6 6 6], player_code: '5531', result: ['', '', '-', ''] },
          { secret_code: %w[5 4 1 1], player_code: '2436', result: ['', '+', '', ''] },
          { secret_code: %w[2 3 3 3], player_code: '4153', result: ['', '', '', '+'] },
          { secret_code: %w[2 3 3 3], player_code: '3445', result: ['-', '', '', ''] },
          { secret_code: %w[2 3 3 3], player_code: '4562', result: ['', '', '', '-'] },
          { secret_code: %w[6 5 1 2], player_code: '6346', result: ['+', '', '', ''] },
          { secret_code: %w[6 5 1 2], player_code: '3314', result: ['', '', '+', ''] },
          { secret_code: %w[6 5 1 2], player_code: '3443', result: ['', '', '', ''] }
        ]
        codes.each do |value|
          it "returns the result #{value[:result]} of guessing the secret code #{value[:secret_code]}" do
            data_processing.instance_variable_set(:@secret_code, value[:secret_code])
            game.player_code = value[:player_code]
            expect(game.guess).to eq(value[:result])
          end
        end
      end
    end

    describe '#save_score' do
      let(:filename) { Dir.pwd + '/result.yml' }
      let(:name) { 'mike' }
      let(:result) { 'Game over!' }
      let(:count_help) { game.count_help }
      let(:count_step) { game.instance_variable_set(:@count_step, 5) }

      before do
        File.delete(filename) if File.exist?(filename)
        data_processing.instance_variable_set(:@result_matches, %w[1 3 5 7])
        data_processing.game_data(name, result, count_help, count_step)
      end

      it 'saves the result of the game to a YAML file' do
        data = [data_processing.result_game]
        expect(File).to receive(:write).with(filename, data.to_yaml)
        game.save_score
      end

      it 'checks whether the game data is stored in a file' do
        time = Time.now.strftime('%Y-%m-%d %H:%M')
        hint = "#{count_help}/#{Game::COUNT_HINT}"
        steps = "#{count_step}/#{Game::COUNT_MOVES}"
        score = data_processing.send(:score)
        game.save_score
        data = YAML.safe_load(File.read(filename))
        expect(data[0]['Result']).to eq(result)
        expect(data[0]['Name']).to eq(name)
        expect(data[0]['Time']).to eq(time)
        expect(data[0]['Hint']).to eq(hint)
        expect(data[0]['Steps']).to eq(steps)
        expect(data[0]['Score']).to eq(score)
        expect(data[0]['Secret code']).to eq(game.instance_variable_get(:@secret_code).join)
      end
    end

    describe '#win?' do
      context 'returns true if the code is guessed, otherwise false' do
        it 'return true' do
          game.data_processing.instance_variable_set(:@result_matches, %w[+ + + +])
          expect(game.win?).to eq(true)
        end
        it 'return false' do
          game.data_processing.instance_variable_set(:@result_matches, %w[- - - -])
          expect(game.win?).to eq(false)
        end
      end
    end

    describe '#loses_game?' do
      context 'returns true if the steps are completed, otherwise false' do
        it 'return true' do
          game.instance_variable_set(:@count_step, 6)
          expect(game.loses_game?).to eq(true)
        end
        it 'return false' do
          game.instance_variable_set(:@count_step, 3)
          expect(game.loses_game?).to eq(false)
        end
      end
    end
  end
end
