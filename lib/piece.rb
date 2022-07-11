require_relative "board"

class Piece
    attr_accessor :color, :sym
    def initialize(color=nil)
        @color = color
        @sym = nil
    end

    def data(row,column,array)
        array[row][column].data
    end
end


class Pwan < Piece
   def initialize(color)
       super(color)
       @sym = " \u265F "
   end

   def legal_move(origin,board_array, move=[])
        row,column = origin
        color = data(row,column,board_array).color
        move << [pattern_of_pwan(row,color),column] if row+1 != boundary(color) && board_array[pattern_of_pwan(row,color)][column].data.nil?
        move << [double_move_of_pwan(row, color),column] if row == initial_pwan_position(color) && board_array[double_move_of_pwan(row,color)][column].data.nil?
        move
   end

   def capturing_move(origin, board_array, o_color, move=[])
        row,column = origin
        color = data(row,column,board_array).color
        move << [pattern_of_pwan(row,color), column+1] if pattern_of_pwan(row,color) != boundary(color) && 
        column+1 != 8 && !r_possible_move(row,column,board_array,color).nil? && 
        r_possible_move(row,column,board_array,color)!= "\u25CF" && 
        r_possible_move(row,column,board_array,color).color == o_color

        move << [pattern_of_pwan(row,color), column-1] if pattern_of_pwan(row,color) != boundary(color) && 
        column-1 != -1 && !l_possible_move(row,column,board_array,color).nil? && 
        l_possible_move(row,column,board_array,color)!= "\u25CF" && 
        l_possible_move(row,column,board_array,color).color == o_color
        move
   end

    def pattern_of_pwan(row, color)
        color == "black"? row + 1 : row - 1
    end

    def double_move_of_pwan(row,color)
        color == "black"? row + 2 : row -2
    end

    def initial_pwan_position(color)
        color == "black"? 1 : 6
    end

    def boundary(color)
        color == "black"? 8 : -1
    end

    def r_possible_move(row,column,array,color)
        color == "black"? data(pattern_of_pwan(row,color),column+1, array) : data(pattern_of_pwan(row,color),column+1, array)
    end

    def l_possible_move(row,column,array,color)
        color == "black"? data(pattern_of_pwan(row,color),column-1, array) : data(pattern_of_pwan(row,color),column-1, array)
    end   

end


class Rook < Piece
    @@move_pattern = [[0, 1], [0, -1], [-1, 0], [1, 0]]
    def initialize(color)
        super(color)
        @sym = " \u265C "
    end

    def legal_move(origin,board_array, move=[])
        @@move_pattern.map do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            while next_location[0].between?(0, 7) && next_location[1].between?(0, 7) && board_array[next_location[0]][next_location[1]].data.nil?
                move << next_location
                next_location = [pattern[0]+next_location[0],pattern[1]+next_location[1]]
            end
        end
        move
    end

    def capturing_move(origin,board_array, color, move=[])
        @@move_pattern.map do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            while next_location[0].between?(0, 7) && next_location[1].between?(0, 7)
                if !board_array[next_location[0]][next_location[1]].data.nil?
                    move << next_location if board_array[next_location[0]][next_location[1]].data != "\u25CF" &&board_array[next_location[0]][next_location[1]].data.color == color
                    break
                end
                next_location = [pattern[0]+next_location[0],pattern[1]+next_location[1]]
            end
        end
        move
    end
end

class Knight < Piece
    @@move_pattern = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
    def initialize(color)
        super(color)
        @sym = " \u265E "
    end

    def legal_move(origin,board_array, move=[])
        @@move_pattern.map do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            move << next_location if next_location[0].between?(0, 7) && next_location[1].between?(0, 7) && board_array[next_location[0]][next_location[1]].data.nil?
        end
        move
    end

    def capturing_move(origin, board_array, color, move=[])
        @@move_pattern.map do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            move << next_location if next_location[0].between?(0, 7) && next_location[1].between?(0, 7) &&
            !board_array[next_location[0]][next_location[1]].data.nil? && board_array[next_location[0]][next_location[1]].data != "\u25CF" && board_array[next_location[0]][next_location[1]].data.color == color
        end
        move
    end
end

class Bishop < Piece
    @@move_pattern = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    def initialize(color)
        super(color)
        @sym = " \u265D "
    end
    def legal_move(origin,board_array, move=[])
        @@move_pattern.map do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            while next_location[0].between?(0, 7) && next_location[1].between?(0, 7) && board_array[next_location[0]][next_location[1]].data.nil?
                move << next_location
                next_location = [pattern[0]+next_location[0],pattern[1]+next_location[1]]
            end
        end
        move
    end

    def capturing_move(origin,board_array, color, move=[])
        @@move_pattern.map do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            while next_location[0].between?(0, 7) && next_location[1].between?(0, 7)
                if !board_array[next_location[0]][next_location[1]].data.nil?
                    move << next_location if board_array[next_location[0]][next_location[1]].data != "\u25CF" &&board_array[next_location[0]][next_location[1]].data.color == color
                    break
                end
                next_location = [pattern[0]+next_location[0],pattern[1]+next_location[1]]
            end
        end
        move
    end
    

end

class Qeen < Piece
    @@move_pattern = [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    def initialize(color)
        super(color)
        @sym = " \u265B "
    end

    def legal_move(origin,board_array, move=[])
        @@move_pattern.map do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            while next_location[0].between?(0, 7) && next_location[1].between?(0, 7) && board_array[next_location[0]][next_location[1]].data.nil?
                move << next_location
                next_location = [pattern[0]+next_location[0],pattern[1]+next_location[1]]
            end
        end
        move
    end

    def capturing_move(origin,board_array, color, move=[])
        @@move_pattern.map do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            while next_location[0].between?(0, 7) && next_location[1].between?(0, 7)
                if !board_array[next_location[0]][next_location[1]].data.nil?
                    move << next_location if board_array[next_location[0]][next_location[1]].data != "\u25CF" &&board_array[next_location[0]][next_location[1]].data.color == color
                    break
                end
                next_location = [pattern[0]+next_location[0],pattern[1]+next_location[1]]
            end
        end
        move
    end
end

class King < Piece
    @@move_pattern = [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    attr_accessor :l_castle, :r_castle
    def initialize(color)
        super(color)
        @sym = " \u265A "
        @l_castle = true
        @r_castle = true
    end
    
    def legal_move(origin,board_array,move=[])
        @@move_pattern.each do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            if next_location[0].between?(0, 7) && next_location[1].between?(0, 7) && board_array[next_location[0]][next_location[1]].data.nil?
                move << next_location
            end
        end
        move
    end

    def capturing_move(origin, board_array, color, move=[])
        @@move_pattern.each do |pattern|
            next_location = [pattern[0]+origin[0],pattern[1]+origin[1]]
            if next_location[0].between?(0, 7) && next_location[1].between?(0, 7) &&
                !board_array[next_location[0]][next_location[1]].data.nil? &&
                board_array[next_location[0]][next_location[1]].data != "\u25CF" &&
                board_array[next_location[0]][next_location[1]].data.color == color
                move << next_location
            end
        end
        move
    end
end