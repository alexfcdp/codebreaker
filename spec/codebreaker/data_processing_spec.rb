require_relative '../spec_helper'
require 'simplecov'
SimpleCov.start

module Codebreaker
  RSpec.describe GameDataProcessing do
    describe '#check_full_match' do
      context 'returns always all "+" when the secret code is guessed' do
        codes = [
          { secret_code: %w[1 2 3 4], player_code: %w[1 2 3 4], result: %w[+ + + +] },
          { secret_code: %w[2 4 2 6], player_code: %w[2 4 2 6], result: %w[+ + + +] },
          { secret_code: %w[1 1 1 1], player_code: %w[1 1 1 1], result: %w[+ + + +] },
          { secret_code: %w[2 5 3 5], player_code: %w[2 5 3 5], result: %w[+ + + +] },
          { secret_code: %w[2 2 6 6], player_code: %w[2 2 6 6], result: %w[+ + + +] },
          { secret_code: %w[5 5 5 5], player_code: %w[5 2 3 5], result: %w[+ 2 3 +] },
          { secret_code: %w[6 6 6 6], player_code: %w[2 4 2 6], result: %w[2 4 2 +] },
          { secret_code: %w[5 4 1 1], player_code: %w[2 3 1 1], result: %w[2 3 + +] },
          { secret_code: %w[2 3 3 3], player_code: %w[4 4 4 3], result: %w[4 4 4 +] },
          { secret_code: %w[5 4 2 3], player_code: %w[4 + 4 4], result: %w[4 + 4 4] },
          { secret_code: %w[4 4 1 2], player_code: %w[4 2 2 2], result: %w[+ 2 2 +] },
          { secret_code: %w[5 6 5 5], player_code: %w[5 3 5 5], result: %w[+ 3 + +] },
          { secret_code: %w[3 3 1 2], player_code: %w[1 2 3 3], result: %w[1 2 3 3] },
          { secret_code: %w[4 2 2 4], player_code: %w[2 4 4 2], result: %w[2 4 4 2] },
          { secret_code: %w[6 5 1 2], player_code: %w[3 5 1 4], result: %w[3 + + 4] }
        ]
        codes.each do |value|
          it 'the player code is the same the secret code' do
            data = GameDataProcessing.new(value[:secret_code])
            data.gamer_code = value[:player_code]
            expect(data.check_full_match).to eq(value[:result])
          end
        end
      end

      describe '#check_any_matches' do
        context 'when the player code does not guessed, \
                 checks if there is a number in the code, \
                 but in a different order' do
          codes = [
            { secret_code: %w[1 2 3 4], player_code: %w[4 3 2 1], result: %w[- - - -] },
            { secret_code: %w[2 4 2 6], player_code: %w[2 6 2 4], result: %w[+ - + -] },
            { secret_code: %w[1 1 1 1], player_code: %w[2 2 2 2], result: ['', '', '', ''] },
            { secret_code: %w[2 5 3 5], player_code: %w[5 2 3 6], result: ['-', '-', '+', ''] },
            { secret_code: %w[2 2 6 6], player_code: %w[1 3 4 2], result: ['', '', '', '-'] },
            { secret_code: %w[5 5 5 5], player_code: %w[5 2 3 5], result: ['+', '', '', '+'] },
            { secret_code: %w[6 6 6 6], player_code: %w[2 4 2 6], result: ['', '', '', '+'] },
            { secret_code: %w[5 4 1 1], player_code: %w[4 3 1 1], result: ['-', '', '+', '+'] },
            { secret_code: %w[2 3 3 3], player_code: %w[3 2 4 3], result: ['-', '-', '', '+'] },
            { secret_code: %w[5 4 4 1], player_code: %w[2 4 4 5], result: ['', '+', '+', '-'] },
            { secret_code: %w[3 3 1 5], player_code: %w[4 3 1 3], result: ['', '+', '+', '-'] },
            { secret_code: %w[6 6 2 6], player_code: %w[6 6 4 6], result: ['+', '+', '', '+'] },
            { secret_code: %w[2 3 3 2], player_code: %w[4 3 3 2], result: ['', '+', '+', '+'] },
            { secret_code: %w[5 4 2 3], player_code: %w[4 4 4 4], result: ['', '+', '', ''] },
            { secret_code: %w[3 1 1 4], player_code: %w[1 4 1 3], result: %w[- - + -] }
          ]
          codes.each do |value|
            it 'when the player code is not guessed, it looks for whether there are \
                the same numbers in the secret code but in different places' do
              data = GameDataProcessing.new(value[:secret_code])
              data.gamer_code = value[:player_code]
              data.check_full_match
              expect(data.check_any_matches).to eq(value[:result])
            end
          end
        end
      end

      describe '#score' do
        let(:points) { { %w[+ + + +] => 100, %w[- - - -] => 60, ['', '', '', ''] => 0, ['+', '-', '', '-'] => 55 } }
        let(:data_processing) { GameDataProcessing.new(%w[1 2 3 4]) }
        it 'returns score points' do
          points.each do |key, value|
            data_processing.instance_variable_set(:@result, key)
            expect(data_processing.send(:score)).to eq(value)
          end
        end
      end
    end
  end
end
