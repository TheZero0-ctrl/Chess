require_relative "board"
require_relative "display"
require_relative "player"

class Game
    include Display
    attr_accessor :board, :play_game, :player1, :player2, :other_player, :current_player
    def initialize
        @board = Board.new
        @player1 = Player.new("player_1", "white")
        @player2 = Player.new("player_2", "black")
        @current_player = player1
        @other_player = player2
        @play_game = false
    end

    def play
        description
        @play_game = true if gets.chomp.downcase == "y"
        board.initial_position
        while play_game
            player_play
            switch_trun
            player_play
            switch_trun
        end
    end

    def get_input
        location = gets.chomp.split("")
        until location.length == 2 && location[0].downcase.between?("a","h") && location[1].to_i.between?(1,8)
            puts "invalid selection select again"
            location = gets.chomp("")
        end
        valid_row_column(location[1], location[0])
    end

    def alphabet_to_column(alphabet)
        {
            "a" => 0,
            "b" => 1,
            "c" => 2,
            "d" => 3,
            "e" => 4,
            "f" => 5,
            "g" => 6,
            "h" => 7
        }[alphabet]
    end

    def legal_selection() #force player to select piece that can be moved my current player
        location = get_input
        row, column = location
        until !board_array[row][column].data.nil? && board_array[row][column].data.color == @current_player.color && !board.legal_move([row,column],board_array,board_array[row][column].data).empty?
            puts "You cannot move this square"
            puts "select another square"
            location = get_input
            row, column = location
        end
        location
    end

    def legal_distination(legal_move)
        location=get_input
        until legal_move.include?(location)
            puts "you cannot move to this square"
            puts "select another square"
            location = get_input
        end
        location
    end

    def valid_row_column(row, column)  # convert ["1","a"] to [7,0]
        row = (row.to_i - 8).abs
        column = alphabet_to_column(column.downcase)
        [row, column]
    end

    def board_array
        @board.board_array
    end

    def make_cell_active(location)
        row,column = location
        board_array[row][column].active = true
    end

    def switch_trun
        @current_player,@other_player = @other_player,@current_player
    end

    def player_play
        display_board(board_array)
        puts "#{current_player.name}, Select the square to move"
        origin = legal_selection
        row,column = origin
        make_cell_active(origin)
        legal_move = @board.legal_move([row,column],board_array,board_array[row][column].data)
        show_move(legal_move, board_array)
        display_board(board_array)
        puts "#{current_player.name}, Select square where you want to move"
        distination = legal_distination(legal_move)
        board.move_piece(origin, distination,board_array)
        make_cell_active(origin)
        reset_display(board_array)
        make_cell_active(distination)
    end
end