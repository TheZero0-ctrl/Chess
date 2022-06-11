require_relative "../lib/board"
require_relative "../lib/display"
require_relative "../lib/cell"
require_relative "../lib/game"
require_relative "../lib/piece"

describe Board do
    let(:board){Board.new}
    describe "#build_board" do
        it "returns white" do
            expect(board.build_board[0][0].color).to eq("white")
        end
        it "returns black" do
            expect(board.build_board[0][1].color).to eq("black")
        end
        it "returns black" do
            expect(board.build_board[2][3].color).to eq("black")
        end
        it "returns black" do
            expect(board.build_board[7][0].color).to eq("black")
        end
        it "returns white" do
            expect(board.build_board[4][4].color).to eq("white")
        end
        it "returns white" do
            expect(board.build_board[7][7].color).to eq("white")
        end
    end

    describe "#decide_color_of_cell" do
        it "returns cell of color white" do
            expect(board.decide_color_of_cell(2,2).color).to eq("white")
        end
        it "returns cell of black color" do
            expect(board.decide_color_of_cell(2,3).color).to eq("black")
        end
    end

    describe "#put_piece" do
        it "puts knight on board" do
            board.put_piece(board.knight("black"), 2, 0)
            expect(board.board_array[2][0].data.class).to eq(Knight)
        end
    end

    describe "#pwan"do
        it "returns the class of Pwan" do
            expect(board.pwan("black").class).to eq (Pwan)
        end
    end

    describe "#initial_position" do
        it "checks correct position of black pwan" do
            board.initial_position
            expect(board.board_array[1][1].data.class).to eq(Pwan)
        end

        it "check correct position of white pwan" do
            board.initial_position
            expect(board.board_array[6][0].data.class).to eq(Pwan)
        end

        it "checks corrects position of black rook" do
            board.initial_position
            expect(board.board_array[0][0].data.class).to eq(Rook)
        end

        it "checks corrects position of white rook" do
            board.initial_position
            expect(board.board_array[7][7].data.class).to eq(Rook)
        end
        
        it "returns nil if there is no piece" do
            board.initial_position
            expect(board.board_array[5][3].data).to eq(nil)
        end
    end

    describe "#legal_move" do
        it "return the legal move of pwan" do
            board.initial_position
            expect(board.legal_move([6,3],board.board_array,board.board_array[6][3].data)).to eq([[5,3],[4,3]])
        end
        it "return the legal move of Rook" do
            expect(board.legal_move([0,0], board.board_array, board.rook("black"))).to eq([
                [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
                [1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
            ])
        end
    end

    describe "#move_piece" do
        it "move rook from [0,0] to [5,0] and data on [0,0] became nil" do
            board.put_piece(board.rook("black"),0,0)
            board.move_piece([0,0], [5,0], board.board_array)
            expect(board.board_array[0][0].data).to eq(nil)
        end

        it "move rook from [0,0] to [5,0], data on [5,0] became rook" do
            board.put_piece(board.rook("black"),0,0)
            board.move_piece([0,0], [5,0], board.board_array)
            expect(board.board_array[5][0].data.class).to eq(Rook)
        end
    end

end

describe Game do
    let(:game) {Game.new}
    describe "#alphabet_to_column" do
        it "returns 1 for b" do
            expect(game.alphabet_to_column("b")).to eq(1)
        end
    end
    describe "#valid_row_column" do
        it "converts ['6','d'] to [2,3]" do
            expect(game.valid_row_column("6","d")).to eq([2,3])
        end
    end
end

describe Rook do
    let(:rook) {Rook.new("black")}
    let(:game) {Game.new}
    describe "#legal_move" do
        it "returns the move rook can make" do
            expect(rook.legal_move([0,0], game.board_array)).to eq([
                [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
                [1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
            ])
        end

        it "dont return the sqaure which contains piece" do
            game.board.initial_position
            expect(rook.legal_move([0,0], game.board_array)).to be_empty
        end
    end

    describe "#capturing_move" do
        it "return the location that it can capture" do
            game.board.put_piece(game.board.pwan("white"),2,5)
            expect(rook.capturing_move([2,2], game.board_array, "white")).to eq([[2,5]])
        end

        it "return multiple location it can capture while ignoring same color" do
            game.board.put_piece(game.board.pwan("white"),2,5)
            game.board.put_piece(game.board.pwan("white"),2,6)
            game.board.put_piece(game.board.pwan("white"),5,2)
            game.board.put_piece(game.board.pwan("black"),2,0)
            expect(rook.capturing_move([2,2], game.board_array, "white")).to eq([[2,5],[5,2]])
        end
    end
end