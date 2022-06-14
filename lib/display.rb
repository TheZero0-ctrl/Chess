module Display
    def display_board(board)
        system "clear"
        board.each_with_index do |row, i|
            print "\e[36m #{(i-8).abs} \e[0m"
            row.each {|cell| print display_cell(cell,cell.data)}
            puts
        end
        puts "\e[36m    A  B  C  D  E  F  G  H \e[0m"
        
    end

    def display_cell(cell,piece)
        "\e[#{piece_color(piece)};#{background(cell)}m#{piece_to_show(piece)}\e[0m" 
    end

    def background(cell)
        if cell.capture == true
            101
        elsif cell.active == true
            106
        else
            cell.color == "black" ? 100 : 47  
        end
    end

    def piece_color(piece)
        if !piece.nil?
            if piece == "\u25CF"
                91
            else
                piece.color == "black"? 30 : 10
            end
        else
            30
        end
    end

    def piece_to_show(piece)
        if piece.nil?
            "   "
        elsif piece == "\u25CF"
            " \u25CF "
        else
            piece.sym
        end
    end

    def description
        system "clear"
        puts "########## Chess ##########"
        puts
        puts "to play first enter the position of chess to move in formate of A1 A2"
        puts "then enter the position where you want to move"
        puts "press Q to load game and press S to save game"
        puts "you can enter L to left castle and R to do right castle"
        puts "press y to start game"
    end

    def show_move(moves,board)
        moves.each {|move| board[move[0]][move[1]].data = "\u25CF"}
    end

    
    def reset_display(board)
        board.each do |row|
            row.each do |cell|
                cell.capture = false if cell.capture == true
               cell.active = false if cell.active == true
               cell.data = nil if cell.data == "\u25CF"
            end
        end
    end
end