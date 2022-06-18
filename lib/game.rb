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
        if location.length == 1 && ["l","r"].include?(location[0].downcase)
            if check_for_castaling?(location[0])
                location[0]
            else
                puts "you cannot do this castle"
                get_input
            end
        else   
            until location.length == 2 && location[0].downcase.between?("a","h") && location[1].to_i.between?(1,8)
                puts "invalid selection select again"
                location = gets.chomp("")
            end
            valid_row_column(location[1], location[0])
        end
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
        location = get_input
        if ["l","r"].include?(location)
            location
        else
            if check?
                row, column = location
                until !board_array[row][column].data.nil? && board_array[row][column].data.color == @current_player.color && !selection_condition_when_check.empty? && selection_condition_when_check.include?(location)
                    puts "You cannot move this square"
                    puts "select another square"
                    location = get_input
                    row, column = location
                end
                location
            else
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
    end

    def legal_distination(legal_move,capturing_move,origin)
        if check?
            location=get_input
            until legal_move.include?(location) || capturing_move.include?(location)
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
            if ["r","l"].include?(origin)
                castle(origin,current_player.color)
                display_board(board_array)
            else
                row,column = origin
                make_left_castle_false(current_player.color,origin)
                make_right_castle_false(current_player.color,origin)
                mark_cell_to_move_and_capture(origin, capturing_move(origin))
                legal_move = legal_move(origin)
                capturing_move = capturing_move(origin)
                show_move(legal_move, board_array)
                display_board(board_array)
                puts "#{current_player.name}, Select square where you want to move"
                distination = legal_distination(legal_move, capturing_move, origin)
                board.move_piece(origin, distination,board_array)
                prompte_pwan(distination) if board_array[distination[0]][distination[1]].data.class == Pwan
                make_cell_active(origin)
                reset_display(board_array)
                make_cell_active(distination)
            end
        end
    end

    def legal_move(origin)
        filter_legal_move(origin)
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
            reset_castle_status
            @play_game = true
        else
            @play_game = false
        end
    end

    def check_for_castaling?(castle_type)
        board.check_for_castaling?(king(current_player.color),castle_type,board_array,other_player.color,current_player.color)
    end

    def king(color)
        row,column =find_king(color)
        board_array[row][column].data
    end

    def castle(castle_type,c_color)
        if castle_type == "l"
            c_color == "black"? left_black_castle : left_white_castle
        elsif castle_type == "r"
            c_color == "black"? right_black_castle : rigth_white_castle
        end
    end

    def left_black_castle
        board.move_piece([0,0],[0,3],board_array)
        board.move_piece([0,4],[0,2],board_array)
    end

    def left_white_castle
        board.move_piece([7,0],[7,3],board_array)
        board.move_piece([7,4],[7,2],board_array)
    end

    def rigth_white_castle
        board.move_piece([7,7],[7,5],board_array)
        board.move_piece([7,4],[7,6],board_array)
    end

    def right_black_castle
        board.move_piece([0,7],[0,5],board_array)
        board.move_piece([0,4],[0,6],board_array)
    end

    def make_left_castle_false(color,origin)
        if color == "white" && (origin == [7,4] || origin == [7,0])
            king(color).l_castle = false
        elsif color == "black" && (origin == [0,4] || origin == [0,0])
            king(color).l_castle = false
        end
    end

    def make_right_castle_false(color,origin)
        if color == "white" && (origin == [7,4] || origin == [7,7])
            king(color).r_castle = false
        elsif color == "black" && (origin == [0,4] || origin == [0,7])
            king(color).r_castle = false
        end
    end

    def reset_castle_status
        king("black").r_castle = true
        king("black").l_castle = true
        king("white").r_castle = true
        king("white").l_castle = true
    end
end