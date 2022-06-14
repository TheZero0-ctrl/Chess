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

    def legal_selection #force player to select piece that can be moved my current player
        if check?
            location = get_input
            row, column = location
            until !board_array[row][column].data.nil? && board_array[row][column].data.color == @current_player.color && !selection_condition_when_check.empty? && selection_condition_when_check.include?(location)
                puts "You cannot move this square"
                puts "select another square"
                location = get_input
                row, column = location
            end
            location
        else
            location = get_input
            row, column = location
            until !board_array[row][column].data.nil? && board_array[row][column].data.color == @current_player.color && (!legal_move(location).empty? || !capturing_move(location).empty?)
                puts "You cannot move this square"
                puts "select another square"
                location = get_input
                row, column = location
            end
            location
        end
        
    end

    def legal_distination(legal_move,capturing_move,origin)
        if check?
            location=get_input
            until target_when_check(origin)[0].include?(location) || legal_move.include?(location) || capturing_move.include?(location)
                puts "you cannot move to this square"
                puts "select another square"
                location = get_input
            end
            location
        else
            location=get_input
            until legal_move.include?(location) || capturing_move.include?(location)
                puts "you cannot move to this square"
                puts "select another square"
                location = get_input
            end
            location
        end
        
    end

    def valid_row_column(row, column)  # convert ["1","a"] to [7,0]
        row = (row.to_i - 8).abs
        column = alphabet_to_column(column.downcase)
        [row, column]
    end

    def board_array
        @board.board_array
    end

    def mark_cell_to_move_and_capture(location,locations)
        make_cell_active(location)
        make_cell_capturing(locations)
    end

    def make_cell_active(location)
        row,column = location
        board_array[row][column].active = true
    end

    def make_cell_capturing(locations)
        locations.each do |location|
            row,column = location
            board_array[row][column].capture = true
        end
    end

    def switch_trun
        @current_player,@other_player = @other_player,@current_player
    end

    def player_play
        display_board(board_array)
        if check_mate?
            display_board(board_array)
            puts "#{current_player.name}, you got check mate"
            play_again
        else
            if check?
                puts "you got check"
            end
            puts "#{current_player.name}, Select the square to move"
            origin = legal_selection
            row,column = origin
            mark_cell_to_move_and_capture(origin, capturing_move(origin))
            legal_move = legal_move(origin)
            capturing_move = capturing_move(origin)
            show_move(legal_move, board_array)
            display_board(board_array)
            puts "#{current_player.name}, Select square where you want to move"
            distination = legal_distination(legal_move, capturing_move, origin)
            board.move_piece(origin, distination,board_array)
            prompte_pwan(distination)
            make_cell_active(origin)
            reset_display(board_array)
            make_cell_active(distination)
        end
    end

    def legal_move(origin)
        row, column = origin
        if board_array[row][column].data.class == King
            board.king_legal_move(origin,board_array,other_player.color,current_player.color,board_array[row][column].data)
        else
            filter_legal_move(origin)
        end
        
    end

    def capturing_move(origin,c_move=[])
        row,column = origin
        board.capturing_move(origin, board_array, other_player.color, board_array[row][column].data).each do |move|
            piece_at_dist = board_array[move[0]][move[1]].data
            board.move_piece(origin,move,board_array)
            if !check?
                c_move << move
            end
            board.move_piece(move,origin,board_array)
            board_array[move[0]][move[1]].data = piece_at_dist
        end
        c_move
    end

    def selection_condition_when_check
        legal_move = []
        board.moveable_piece(find_king(current_player.color),other_player.color,current_player.color).each do |origin,distination|
            legal_move << origin
        end
        board.able_to_capture(find_king(current_player.color),other_player.color,current_player.color).each do |origin,distination|
            legal_move << origin
        end
        legal_move
    end

    def target_when_check(selection)
        legal_target = []
        board.moveable_piece(find_king(current_player.color),other_player.color,current_player.color).each do |origin,distination|
            legal_target <<  distination if origin == selection
        end
        board.able_to_capture(find_king(current_player.color),other_player.color,current_player.color).each do |origin,distination|
            legal_target << distination if origin == selection
        end
        legal_target
    end

    def find_king(color)
        board_array.each_with_index do |row,i|
            row.each_with_index do |cell,j|
                if !cell.data.nil? && cell.data.class == King && cell.data.color == color
                    return [i,j]
                    break
                end
            end
        end
    end

    def check?
        board.check?(find_king(current_player.color),board_array,other_player.color,current_player.color)
    end

    def check_mate?
        selection_condition_when_check.empty?? true : false
    end

    def filter_legal_move(origin,legal_move=[])
        row,column = origin
        board.legal_move(origin, board_array, board_array[row][column].data).each do |move|
            board.move_piece(origin,move,board_array)
            if !check?
                legal_move << move
            end
            board.move_piece(move,origin,board_array)
        end
        legal_move
    end

    def prompte_pwan(distination)
        row,column = distination
        if @current_player.color == "black" && row == 7
            display_board(board_array)
            puts "type R,K,B,Q to promote it to Rook,Knight,Bishop,Qeen"
            decesion = gets.chomp.downcase
            until decesion == "r" || decesion == "k" || decesion == "b" || decesion == "q"
                decesion = gets.chomp.downcase
            end
            case decesion
            when "r"
                board_array[row][column].data = board.rook("black")
            when "k"
                board_array[row][column].data = board.knight("black")
            when "b"
                board_array[row][column].data = board.bishop("black")
            else
                board_array[row][column].data = board.queen("black")
            end
        end

        if @current_player.color == "white" && row == 0
            display_board(board_array)
            puts "type R,K,B,Q to promote it to Rook,Knight,Bishop,Qeen"
            decesion = gets.chomp.downcase
            until decesion == "r" || decesion == "k" || decesion == "b" || decesion == "q"
                decesion = gets.chomp.downcase
            end
            case decesion
            when "r"
                board_array[row][column].data = board.rook("white")
            when "k"
                board_array[row][column].data = board.knight("white")
            when "b"
                board_array[row][column].data = board.bishop("white")
            else
                board_array[row][column].data = board.qeen("white")
            end
        end
    end

    def play_again
        puts "do you want to play again? y/n"
        if gets.chomp.downcase == "y"
            @board = Board.new
            board.initial_position
            reset_display(board_array)
            @current_player = player2
            @other_player = player1
            @play_game = true
        else
            @play_game = false
        end
    end
end