module Codebreaker
  SIZE_SECRET_CODE = 4
  COUNT_HINT = 1
  COUNT_MOVES = 5
  PLAYER_NAME = 'Player'.freeze
  WON = 'Win!'.freeze
  LOST = 'Lose!'.freeze
  EXACT_MATCH = '+'.freeze
  NUMERICAL_MATCH = '-'.freeze
  NO_MATCHES = ''.freeze
  POINTS = { EXACT_MATCH => 25, NUMERICAL_MATCH => 15 }.freeze
  DELIMITER = ('-' * 40).to_s.freeze
  NO_HINT = 'All hints are exhausted'.freeze
  INPUT_CONDITION = "Enter the code from #{SIZE_SECRET_CODE} numbers from 1 to 6".freeze
end
