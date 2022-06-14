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

    def king_legal_move(origin,board,o_color,c_color,piece)
        piece.legal_move(origin,board).filter{|move| !check?(move,board,o_color,c_color)}
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
                if o_color == "black"
                    row, column = position
                    move << [row+1, column+1] if row+1 != 8 && column+1 != 8
                    move << [row+1, column-1] if row+1 !=8 && column-1 != -1
                else
                    row, column = position
                    move << [row-1, column+1] if row-1 != -1 && column+1 != 8
                    move << [row-1, column-1] if row-1 != -1 && column-1 != -1
                end
            else
                legal_move(position,board,piece).map {|moves| move << moves}
            end
        end
        move.uniq
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
            if piece.class == King
                legal_move = king_legal_move(location,board_array,o_color,c_color,piece)
            else
                legal_move = legal_move(location,board_array,piece)
            end

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

end