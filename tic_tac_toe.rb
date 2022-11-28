# frozen_string_literal: true

# module TicTacToe
module TicTacToe
  def self.setup
    Control.new.play
  end

  # class Player
  class Player
    attr_reader :marker
    attr_accessor :score

    def initialize(marker)
      @marker = marker
      @score = 0
    end

    def mark
      puts "\nPick a number.\n"
      gets.to_i
    end
  end

  # class Model
  class Model
    attr_reader :board, :player1, :player2
    attr_accessor :turn, :available_spots, :result, :marked

    def initialize(player1, player2)
      @turn = 'p1'
      @player1 = player1
      @player2 = player2
      @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      @result = ''
      @available_spots = [0, 1, 2, 3, 4, 5, 6, 7, 8]
      @marked = false
    end
  end

  # class View
  class View
    attr_reader :scores
    attr_accessor :board, :p1_score, :p2_score, :turn, :result

    def initialize
      @board = ''
      @p1_score = 0
      @p2_score = 0
      @turn = ''
      @result = ''
    end

    def update_board(board)
      new_board = <<~HEREDOC
        \t  #{board[0..2].join(' | ')}
        \t ---+---+---
        \t  #{board[3..5].join(' | ')}
        \t ---+---+---
        \t  #{board[6..8].join(' | ')}
      HEREDOC
      self.board = new_board
    end

    def update_scores(p1_score, p2_score)
      self.p1_score = "Player 1's score: #{p1_score}"
      self.p2_score = "Player 2's score: #{p2_score}"
    end

    def update_turn(turn)
      self.turn = turn == 'p1' ? "Player 1's turn" : "Player 2's turn"
    end

    def update_result(result)
      self.result = case result
                    when 'p1'
                      'Player 1 wins.'
                    when 'p2'
                      'Player 2 wins.'
                    when 'tie'
                      'Tie'
                    else
                      ''
                    end
    end
  end

  # class Control
  class Control
    WIN_CONDITIONS = [
      [0, 1, 2], [0, 4, 8], [0, 3, 6], [1, 4, 7],
      [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]
    ].freeze

    attr_accessor :model, :view

    def initialize
      @model = Model.new(Player.new('o'), Player.new('x'))
      @view = View.new
    end

    def play
      loop do
        print_scores
        print_turn
        print_board
        mark_on_board
        break if win? || tie?

        switch_turn!
      end
      game_over
      restart
    end

    def switch_turn!
      return unless model.marked

      model.turn = model.turn == 'p1' ? 'p2' : 'p1'
    end

    def mark_on_board
      model.marked = false
      actual_idx = current_player_mark - 1
      return unless validate_mark(actual_idx)

      model.board[actual_idx] = current_player_marker
      model.marked = true
    end

    def current_player_mark
      model.turn == 'p1' ? model.player1.mark : model.player2.mark
    end

    def current_player_marker
      model.turn == 'p1' ? model.player1.marker : model.player2.marker
    end

    def validate_mark(mark)
      if model.available_spots.include?(mark)
        model.available_spots = model.available_spots.filter { |spot| spot != mark }
        true
      else
        false
      end
    end

    def win?
      marker = model.turn == 'p1' ? 'o' : 'x'
      WIN_CONDITIONS.any? do |condition|
        condition.all? { |spot| model.board[spot] == marker }
      end
    end

    def tie?
      model.board.none?(Integer)
    end

    def game_over
      update_result
      update_score
      print_scores
      print_result
      print_board
    end

    def update_score
      model.result == 'p1' ? model.player1.score += 1 : model.player2.score += 1
    end

    def update_result
      model.result = model.turn if win?
      model.result = 'tie' if tie?
    end

    def restart
      self.model = Model.new(model.player1, model.player2)
      self.view = View.new
      play
    end

    def print_turn
      view.update_turn(model.turn)
      puts "\n#{view.turn}\n"
    end

    def print_scores
      view.update_scores(model.player1.score, model.player2.score)
      puts "\n#{view.p1_score} | #{view.p2_score}\n"
    end

    def print_board
      view.update_board(model.board)
      puts "\n#{view.board}\n"
    end

    def print_result
      view.update_result(model.result)
      puts view.result
    end
  end
end

TicTacToe.setup
