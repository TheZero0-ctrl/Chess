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

        it "dont return the squre which contains piece" do
            game.board.initial_position
            expect(rook.legal_move([0,0], game.board_array)).to be_empty
        end
    end
end