class Piece
    attr_accessor: :color, :sym
    def initialize(color=nil,sym=nil)
        @color = color
        @sym = sym
    end
end

class Pwan < Piece

end

class Rook < Piece

end

class Knight < Piece

end

class Bishop < Piece

end

class Qeen < Piece

end

class King < Piece

end