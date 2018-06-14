require_relative '../spec_helper'
require 'simplecov'
SimpleCov.start

module Codebreaker
  RSpec.describe Game do
    let(:game) { Game.new }

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
      before do
        game.instance_variable_set(:@secret_code, %w[1 2 6 5])
      end

      it 'returns the result ++++ when the code is guessed' do
        game.player_code = '1265'
        expect(game.guess).to eq(%w[+ + + +])
      end
      it 'returns the guessing result if the code does not match' do
        game.player_code = '4645'
        expect(game.guess).to eq(['', '-', '', '+'])
      end
      it 'returns everything blank when the digits is not in the secret code' do
        game.player_code = '4444'
        expect(game.guess).to eq(['', '', '', ''])
      end
      it 'returns ---- when all the digits are not in their places' do
        game.player_code = '6512'
        expect(game.guess).to eq(%w[- - - -])
      end
      it 'passes all the stages of guessing to win' do
        game.instance_variable_set(:@count_step, 3)
        game.player_code = '1256'
        expect(game.guess).to eq(%w[+ + - -])
        game.player_code = '1265'
        expect(game.guess).to eq(%w[+ + + +])
      end
      it 'returns true, when the code is guessed' do
        game.player_code = '1265'
        game.guess
        expect(game.win?).to eq(true)
      end
      it 'returns true when all attempts are exhausted' do
        game.instance_variable_set(:@count_step, 5)
        expect(game.loses_game?).to eq(true)
      end
    end

    describe '#save_score' do
      let(:filename) { Dir.pwd + '/result.yml' }
      let(:name) { 'mike' }
      let(:output) { "Win!\nSecret code: ['5', '1', '1', '2']\nYou took steps 1/#{Game::COUNT_MOVES}" }
      let(:time) { Time.now.strftime('%Y-%m-%d %H:%M') }
      let(:data) { { 'Name' => name, 'Time' => time, 'Result' => output } }

      it 'checks whether the game data is stored in a file' do
        File.delete(filename) if File.exist?(filename)
        game.save_score(name, output)
        data ||= YAML.safe_load(File.read(filename))
        expect(data['Result']).to eq(output)
        expect(data['Name']).to eq(name)
        expect(data['Time']).to eq(time)
      end

      it 'saves the result of the game to a YAML file' do
        file = double(File)
        expect(File).to receive(:open).with(filename, 'a').and_yield(file)
        expect(file).to receive(:puts).with(data.to_yaml)
        game.save_score(name, output)
      end
    end
    describe '#win?' do
      context 'returns true if the code is guessed, otherwise false' do
        it 'return true' do
          game.player_code = %w[+ + + +]
          expect(game.win?).to eq(true)
        end
        it 'return false' do
          game.player_code = %w[+ - + -]
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
