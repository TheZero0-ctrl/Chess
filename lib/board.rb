require_relative "cell"
require_relative "piece"

class Board
    attr_accessor :board_array
    def initialize()
        @board_array = build_board
    end
    
    def initial_position
        # black side
        @board_array[1].each_with_index{|cell,column| put_piece(pwan("black"),1,column)}
        put_piece(rook("black"),0,0)
        put_piece(rook("black"),0,7)
        put_piece(knight("black"),0,1)
        put_piece(knight("black"),0,6)
        put_piece(bishop("black"),0,2)
        put_piece(bishop("black"),0,5)
        put_piece(qeen("black"),0,3)
        put_piece(king("black"),0,4)
        # white side
        @board_array[6].each_with_index{|cell,column| put_piece(pwan("white"),6,column)}
        put_piece(rook("white"),7,0)
        put_piece(rook("white"),7,7)
        put_piece(knight("white"),7,1)
        put_piece(knight("white"),7,6)
        put_piece(bishop("white"),7,2)
        put_piece(bishop("white"),7,5)
        put_piece(qeen("white"),7,3)
        put_piece(king("white"),7,4)
    end

    def build_board
        empty_a = Array.new(8) {Array.new(8){""}}
        empty_a.each_with_index do |row,i|
            row.each_with_index do |item,j|
                empty_a[i][j] = decide_color_of_cell(i,j)
            end
        end
        empty_a
    end

    def decide_color_of_cell(row,column)
        if column%2==0
            if row % 2 == 0
                cell("white")
            else
                cell("black")
            end
        else
            if row % 2 != 0
                cell("white")
            else
                cell("black")
            end
        end
    end

    def put_piece(piece,row,column)
        @board_array[row][column].data = piece
    end

    def cell(color, data=nil)
        Cell.new(color,data)
    end

    def pwan(color)
        Pwan.new(color)
    end

    def rook(color)
        Rook.new(color)
    end

    def knight(color)
        Knight.new(color)
    end

    def bishop(color)
        Bishop.new(color)
    end

    def qeen(color)
        Qeen.new(color)
    end

    def king(color)
        King.new(color)
    end

    def legal_move(origin, board, piece)
        piece.legal_move(origin,board)
    end


    def capturing_move(origin, board, color, piece)
        piece.capturing_move(origin,board,color)
    end

    def move_piece(origin, distination,board_array)
        put_piece(board_array[origin[0]][origin[1]].data, distination[0],distination[1])
        board_array[origin[0]][origin[1]].data = nil
    end

    def get_legal_move_of_all_pieces(board, o_color,move=[])
        pieces_on_board(board,o_color).each do |piece,position|
            if piece.class == Pwan
                row, column = position
                move << [pattern_of_pwan(row,o_color), column+1] if pattern_of_pwan(row,o_color) != 8 && column+1 != 8
                move << [pattern_of_pwan(row,o_color), column-1] if pattern_of_pwan(row,o_color) !=8 && column-1 != -1
            else
                legal_move(position,board,piece).map {|moves| move << moves}
            end
        end
        move.uniq
    end

    def pattern_of_pwan(row, color)
        color == "black"? row + 1 : row - 1
    end
        
    def get_capture_move(board,o_color,c_color,move=[])
        pieces_on_board(board,o_color).each do |piece,position|
            capturing_move(position,board,c_color,piece).map{|moves|move<<moves}
        end
        move.uniq
    end

    def pieces_on_board(board_array,color)
        pieces = {}
        board_array.each_with_index do |row,i|
            row.each_with_index do |column,j|
                if !column.data.nil? && column.data != "\u25CF" && column.data.color == color
                    pieces[column.data] = [i,j]
                end
            end
        end
        pieces
    end

    def check?(king_position, board, o_color,c_color)
        if board[king_position[0]][king_position[1]].data.nil?
            get_legal_move_of_all_pieces(board,o_color).include?(king_position)? true : false
        else
            get_capture_move(board,o_color,c_color).include?(king_position)? true :false
        end
    end

    def moveable_piece(king_position, o_color, c_color, to_move_piece={},movable_loc=[]) 
        pieces = pieces_on_board(board_array, c_color)
        pieces.each do |piece,location|
            legal_move = legal_move(location,board_array,piece)
            if !legal_move.empty?
                legal_move.each_with_index do |move,i|
                    if piece.class == King
                        move_piece(location,move,board_array)
                        king_position = move
                    else
                        move_piece(location,move,board_array)
                    end
                    if !check?(king_position, board_array, o_color,c_color)
                        movable_loc << move
                        to_move_piece[location] = movable_loc
                    end
                    if piece.class == King
                        move_piece(move,location,board_array)
                        king_position = location
                        movable_loc = [] if i == legal_move.length-1
                    else
                        move_piece(move,location,board_array)
                        movable_loc = [] if i == legal_move.length-1
                    end
                    
                end
            end
       end
       to_move_piece
    end

    def able_to_capture(king_position,o_color,c_color,to_move_piece={},movable_loc=[])
        pieces = pieces_on_board(board_array, c_color)
        pieces.each do |piece,location|
            capturing_move = capturing_move(location,board_array,o_color,piece)
            if !capturing_move.empty?
                capturing_move.each_with_index do |move,i|
                    if piece.class == King
                        piece_at_dist = board_array[move[0]][move[1]].data
                        move_piece(location,move,board_array)
                        king_position = move
                    else
                        piece_at_dist = board_array[move[0]][move[1]].data
                        move_piece(location,move,board_array)
                    end
                    if !check?(king_position,board_array,o_color,c_color)
                        movable_loc << move
                        to_move_piece[location] = movable_loc
                    end
                    if piece.class == King
                        move_piece(move,location,board_array)
                        board_array[move[0]][move[1]].data = piece_at_dist
                        movable_loc = [] if i == capturing_move.length-1
                        king_position = location
                    else
                        move_piece(move,location,board_array)
                        board_array[move[0]][move[1]].data = piece_at_dist
                        movable_loc = [] if i == capturing_move.length-1
                    end
                    
                end
            end
                    
        end
        to_move_piece
    end

    def check_for_castaling?(king,castle_type,board_array,o_color,c_color)
        if king.l_castle == true
            if castling_side(castle_type).all? {|column|board_array[king_row(king.color)][column].data.nil?}
                !check?([king_row(king.color),2],board_array,o_color,c_color) ? true : false
            else
                false
            end
        end
    end

    def king_row(color)
        color == black ? 0 : 7
    end

    def castling_side(side)
        side == "l" ? [1,2,3] : [6,5]
    end
end