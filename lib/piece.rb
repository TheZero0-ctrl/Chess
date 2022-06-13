require_relative "board"

class Piece
    attr_accessor :color, :sym
    def initialize(color=nil)
        @color = color
        @sym = nil
    end
end

class Pwan < Piece
   def initialize(color)
       super(color)
       @sym = " \u265F "
   end

   def legal_move(origin,board_array, move=[])
        row,column = origin
        if board_array[row][column].data.color == "black"
            move << [row+1,column] if row+1 != 8 && board_array[row+1][column].data.nil?
            move << [row+2,column] if row == 1 && board_array[row+2][column].data.nil?
        else
            move << [row-1,column] if row-1 != -1 && board_array[row-1][column].data.nil?
            move << [row-2,column] if row == 6 && board_array[row-2][column].data.nil?

        end
        move
   end

   def capturing_move(origin, board_array, color, move=[])
        row,column = origin
        if board_array[row][column].data.color == "black"
            move << [row+1, column+1] if row+1 != 8 && column+1 != 8 && !board_array[row+1][column+1].data.nil? && board_array[row+1][column+1].data.color == color
            move << [row+1, column-1] if row+1 !=8 && column-1 != -1 && !board_array[row+1][column-1].data.nil? && board_array[row+1][column-1].data.color == color
        else
            move << [row-1, column+1] if row-1 != -1 && column+1 != 8 && !board_array[row-1][column+1].data.nil? && board_array[row-1][column+1].data.color == color
            move << [row-1, column-1] if row-1 != -1 && column-1 != -1 && !board_array[row-1][column-1].data.nil? && board_array[row-1][column-1].data.color == color
        end
        move
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
                    move << next_location if board_array[next_location[0]][next_location[1]].data.color == color
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
            !board_array[next_location[0]][next_location[1]].data.nil? && board_array[next_location[0]][next_location[1]].data.color == color
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
                    move << next_location if board_array[next_location[0]][next_location[1]].data.color == color
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
                    move << next_location if board_array[next_location[0]][next_location[1]].data.color == color
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
    def initialize(color)
        super(color)
        @sym = " \u265A "
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
                board_array[next_location[0]][next_location[1]].data.color == color
                move << next_location
            end
        end
        move
    end
end