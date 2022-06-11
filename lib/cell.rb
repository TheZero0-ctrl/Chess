class Cell
    attr_accessor :data, :color, :active
    def initialize(color=nil,data=nil)
        @color = color
        @data = data
        @active = false
    end
end