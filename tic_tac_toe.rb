# frozen_string_literal: true

# This module represents as a container for tic tac toe game
module TicTacToe
  def self.init
    puts 'Welcome to Tic Tac Toe'
    print 'How many rounds do you want to play? '
    rounds = gets.chomp.to_i
    game = Game.new(Player.new('o', 'Player 1'), Player.new('x', 'Player 2'), rounds)
    game.play_until_no_rounds
  end

  # This class represents a tic tac toe game
  class Game
    WIN_CONDITIONS = [
      [0, 1, 2], [0, 4, 8], [0, 3, 6], [1, 4, 7],
      [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]
    ].freeze

    def initialize(player1, player2, rounds)
      @board = Array.new(9) { |index| index + 1 }
      @player1 = player1
      @player2 = player2
      @current_player = @player1
      @rounds = rounds
      @rounds_left = rounds
    end

    def play_until_no_rounds
      loop do
        @board = Array.new(9) { |index| index + 1 }
        play
        break if @rounds_left.zero?
      end
    end

    private

    def play
      loop do
        puts self
        handle_position
        return end_game if game_over?

        change_player
      end
    end

    def change_player
      @current_player = @current_player.marker == 'o' ? @player2 : @player1
    end

    def game_over?
      win? || tie?
    end

    def win?
      WIN_CONDITIONS.any? do |condition|
        condition.all? { |position| @board[position] == @current_player.marker }
      end
    end

    def tie?
      @board.all?(String)
    end

    def end_game
      if win?
        @message = "#{@current_player.name} wins."
        @current_player.points += 1
      elsif tie?
        @message = 'Draw.'
      end
      @rounds_left -= 1
      puts self
    end

    def handle_position
      print 'Pick a position: '
      position = gets.chomp.to_i - 1
      @board[position] = @current_player.marker
    end

    def to_s
      <<~HEREDOC

        ---------
          Rounds: #{@rounds_left} of #{@rounds}

          Current player: #{@current_player.name}
            Marker: #{@current_player.marker}

          Board

            #{@board[0..2].join(' | ')}
            ---+---+---
            #{@board[3..5].join(' | ')}
            ---+---+---
            #{@board[6..8].join(' | ')}

          Scores

            #{@player1.name}: #{@player1.points}  |  #{@player2.name}: #{@player2.points}
            #{"\n#{@message}\n" unless @message.nil?}
        ---------

      HEREDOC
    end
  end

  # This class represents a player for the tic tac toe game
  class Player
    attr_reader :marker, :name
    attr_accessor :points

    def initialize(marker, name)
      @marker = marker
      @name = name
      @points = 0
    end
  end
end

TicTacToe.init
