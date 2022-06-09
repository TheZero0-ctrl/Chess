class Cell
    attr_accessor :data, :color
    def initialize(color=nil,data=nil)
        @color = color
        @data = data
    end
end