class Cell
    attr_accessor :data, :color, :active, :capture
    def initialize(color=nil,data=nil)
        @color = color
        @data = data
        @active = false
        @capture = false
    end
end