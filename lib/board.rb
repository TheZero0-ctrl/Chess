require_relative "cell"

class Board
    attr_accessor :initial_position
    def initialize()
        @initial_position = build_board
    end

    def assign_color_to_cell
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

    def build_board
        assign_color_to_cell[1].each {|cell| cell.data=pwan("black","/u265F")}
    end

    def cell(color, data=nil)
        Cell.new(color,data)
    end

    def pwan(color, sym)
        Pwan.new(color,sym)
    end

    def hook(color, sym)
        Hook.new(color,sym)
    end

    def knight(color, sym)
        Knight.new(color,sym)
    end

    def bishop(color, sym)
        Bishop.new(color,sym)
    end

    def qeen(color, sym)
        Qeen.new(color,sym)
    end

    def king(color, sym)
        King.new(color,sym)
    end
end