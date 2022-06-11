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

    def move_piece(origin, distination,board_array)
        board_array[distination[0]][distination[1]].data = board_array[origin[0]][origin[1]].data
        board_array[origin[0]][origin[1]].data = nil
    end
end