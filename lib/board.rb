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

    def king_legal_move(origin,board,color,piece)
        piece.legal_move(origin,board).filter{|move| !check?(move,board,color)}
    end

    def capturing_move(origin, board, color, piece)
        piece.capturing_move(origin,board,color)
    end

    def move_piece(origin, distination,board_array)
        put_piece(board_array[origin[0]][origin[1]].data, distination[0],distination[1])
        board_array[origin[0]][origin[1]].data = nil
    end

    def get_legal_move_of_all_pieces(board, color,move=[])
        pieces_on_board(board,color).each do |piece,position|
            if piece.class == Pwan
                if color == "black"
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


    def pieces_on_board(board_array,color)
        pieces = {}
        board_array.each_with_index do |row,i|
            row.each_with_index do |column,j|
                if !column.data.nil? && column.data.color == color
                    pieces[column.data] = [i,j]
                end
            end
        end
        pieces
    end

    def check?(king_position, board, color)
        if get_legal_move_of_all_pieces(board,color).include?(king_position)
            return true
        else
            return false
        end
    end

    def prevent_check(board_array,c_color,o_color,king_position,movable_piece={},movable_loc=[])
       pieces = pieces_on_board(board_array,c_color) 
    end

    def moveable_piece(pieces, move_piece={},movable_loc=[]) 
        pieces.each do |piece,location|
            legal_move = legal_move(location,board_array,piece)
            if !legal_move.empty?
                legal_move.each do |move|
                    move_piece(location,move)
                    if !check?(king_position, board, o_color)
                        movable_loc << move
                        movable_piece[location] = movable_loc
                        move_piece(move,location) 
                    end
                end
            end
       end
       move_piece
    end

end