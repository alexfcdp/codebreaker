require_relative '../spec_helper'
# require 'simplecov'
# SimpleCov.start

module Codebreaker
  RSpec.describe View do
    let(:view) { View.new }
    let(:game) { view.instance_variable_get(:@game) }

    describe '#load_game' do
      before do
        allow(view).to receive(:puts)
        allow(view).to receive(:player_name)
        allow(view).to receive(:loop).and_yield
        allow(view).to receive(:save_result)
        allow(view).to receive(:plays_again)
      end
      it 'returns the result when the player enters the code' do
        allow(view).to receive(:read_input).and_return('1234')
        allow(game).to receive(:start_game)
        game.instance_variable_set(:@secret_code, %w[1 3 4 3])
        game.instance_variable_set(:@count_step, 1)
        view.load_game
        expect(game.player_code).to eq(['+', '', '-', '-'])
      end

      it 'displays the secret numeral when the player enters `h`' do
        allow(view).to receive(:read_input).and_return('h')
        expect(view).to receive(:show_hint)
        view.load_game
      end

      it 'displays `All hints are exhausted` when the hints are over' do
        allow(view).to receive(:read_input).and_return('h')
        allow(game).to receive(:start_game)
        game.instance_variable_set(:@count_step, 1)
        game.instance_variable_set(:@count_help, 2)
        expect(view).to receive(:show_hint)
        view.load_game
      end

      it 'returns true, when the secret code is guessed' do
        game.player_code = '1234'
        game.instance_variable_set(:@secret_code, %w[1 2 3 4])
        game.instance_variable_set(:@count_step, 3)
        expect(view.send(:guessed?)).to be true
      end
      it 'player specifies his name' do
        allow(view).to receive(:player_name).and_return('alexfcdp')
        expect(view.send(:player_name)).to eq('alexfcdp')
      end
    end

    describe '#save_result' do
      it 'the result of the game is saved when the player presses `y`' do
        allow(view).to receive(:puts)
        allow(view).to receive(:read_input).and_return('y')
        name = view.instance_variable_set(:@name_player, 'mike')
        result = "Win!\nSecret code: ['5', '1', '1', '2']\nYou took steps 1/#{Game::COUNT_MOVES}"
        result_game = view.instance_variable_set(:@result_game, result)
        expect(game).to receive(:save_score).with(name, result_game)
        view.send(:save_result)
      end
    end

    describe '#plays_again' do
      it 'the player leaves the game when presses `n`' do
        allow(view).to receive(:puts)
        allow(view).to receive(:read_input).and_return('n')
        expect(view).to receive(:exit)
        view.send(:plays_again)
      end
      it 'new game begins when the player presses `y`' do
        allow(view).to receive(:puts)
        allow(view).to receive(:read_input).and_return('y')
        expect(view).to receive(:load_game)
        view.send(:plays_again)
      end
    end

    describe '#confirm?' do
      it 'returns true on `y`' do
        allow(view).to receive(:read_input).and_return('y')
        expect(view.send(:confirm?)).to be true
      end
      it 'return false on `n`' do
        allow(view).to receive(:read_input).and_return('n')
        expect(view.send(:confirm?)).to be false
      end
    end
  end
end
