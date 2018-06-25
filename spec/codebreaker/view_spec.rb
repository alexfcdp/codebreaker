require_relative '../spec_helper'
require 'simplecov'
SimpleCov.start

module Codebreaker
  RSpec.describe View do
    let(:view) { View.new }
    let(:game) { view.instance_variable_get(:@game) }
    let(:messages) { view.instance_variable_get(:@messages) }
    before { allow_any_instance_of(View).to receive(:view_result_games) }

    describe '#load_game' do
      before do
        allow(view).to receive(:read_input).and_return('n')
        allow(view).to receive(:puts)
        allow(messages).to receive(:puts)
        allow(view).to receive(:player_name)
        allow(view).to receive(:loop).and_yield
        allow(game).to receive(:data_preparation)
        allow(view).to receive(:message_of_result)
        allow(view).to receive(:save_result)
        allow(view).to receive(:view_result_games)
        allow(view).to receive(:plays_again)
      end
      it 'returns the result when the player enters the code' do
        allow(view).to receive(:read_input).and_return('1234')
        allow(game).to receive(:start_game)
        game.instance_variable_set(:@data_processing, GameDataProcessing.new(%w[1 3 4 3]))
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
        game.instance_variable_set(:@data_processing, GameDataProcessing.new(%w[1 2 3 4]))
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
        allow(messages).to receive(:puts)
        allow(view).to receive(:read_input).and_return('y')
        data_processing = GameDataProcessing.new(%w[1 2 4 5])
        name = view.instance_variable_set(:@name_player, 'mike')
        count_help = game.instance_variable_set(:@count_help, 0)
        count_step = game.instance_variable_set(:@count_step, 5)
        data_processing.instance_variable_set(:@result, %w[+ - + -])
        data_processing.game_data(name, 'Game over!', count_help, count_step)
        expect(game).to receive(:save_score)
        view.send(:save_result)
      end
    end

    describe '#plays_again' do
      before do
        allow(view).to receive(:puts)
        allow(messages).to receive(:return_game)
      end
      it 'the player leaves the game when presses `n`' do
        allow(view).to receive(:read_input).and_return('n')
        expect(view).to receive(:exit)
        view.send(:plays_again)
      end
      it 'new game begins when the player presses `y`' do
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
