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

    describe "#check?" do
        context "for the piece other than pwan" do
            it "returns true where there is check" do
                board.put_piece(board.bishop("white"),2,5)
                expect(board.check?([1,4],board.board_array,"white")).to eq(true)
            end
            it "return false where there is not check" do
                board.put_piece(board.bishop("black"),2,5)
                board.put_piece(board.bishop("white"),5,5)
                expect(board.check?([1,4],board.board_array,"white")).to eq(false)
            end

            it "return true" do
                board.initial_position
                board.move_piece([6,3],[4,3],board.board_array)
                board.move_piece([1,3],[3,3],board.board_array)
                board.move_piece([7,4],[6,3],board.board_array)
                board.move_piece([0,2],[3,5],board.board_array)
                expect(board.check?([5,3],board.board_array,"black")).to eq(true)
            end
        end
        context "for the pwan" do
            it "returns true where there is check" do
                board.put_piece(board.bishop("white"),2,5)
                expect(board.check?([1,4],board.board_array,"white")).to eq(true)
            end
            it "returns false where there is no check" do
                board.put_piece(board.bishop("black"),2,5)
                board.put_piece(board.bishop("white"),3,5)
                expect(board.check?([1,4],board.board_array,"white")).to eq(false)
            end
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

    describe "#legal_move" do
        context "for the king" do
            it "ignore the square where it can me checked" do
                game.board.put_piece(game.board.bishop("black"),3,5)
                game.board.put_piece(game.board.king("white"),6,3)
                expect(game.legal_move([6,3])).to eq([
                    [6,4],[7,3],[7,4],[7,2],[5,4],[5,2]
                ])
            end

            it "return legal move" do
                game.board.initial_position
                game.board.move_piece([6,3],[4,3],game.board_array)
                game.board.move_piece([1,3],[3,3],game.board_array)
                game.board.move_piece([7,4],[6,3],game.board_array)
                game.board.move_piece([0,2],[3,5],game.board_array)
                expect(game.legal_move([6,3])).to eq([
                    [7,4],[5,4],[5,2]
                ])
            end
            

        end
    end

    describe "#capturing_move" do
        context "for the king" do
            it "returns empty array" do
                game.board.put_piece(game.board.bishop("black"),5,5)
                game.board.put_piece(game.board.king("black"),2,2)
                expect(game.capturing_move([2,2])).to eq([])
            end

            it "returns empty array" do
                game.board.put_piece(game.board.bishop("black"),3,5)
                game.board.put_piece(game.board.king("white"),6,3)
                expect(game.capturing_move([6,3])).to eq([])
            end

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
            game.board.put_piece(game.board.pwan("black"),1,2)
            game.board.put_piece(game.board.pwan("white"),0,2)
            expect(rook.capturing_move([2,2], game.board_array, "white")).to eq([[2,5],[5,2]])
        end
    end
end

describe Pwan do
    let(:pwan) {Pwan.new("white")}
    let(:game) {Game.new}
    it " returns the location it can capture" do
        game.board.put_piece(game.board.pwan("white"),3,5)
        game.board.put_piece(game.board.pwan("white"),3,3)
        game.board.put_piece(game.board.pwan("black"),2,4)
        expect(pwan.capturing_move([2,4], game.board_array, "white")).to eq([[3,5],[3,3]])
    end
    it "ignore the same color" do
        game.board.put_piece(game.board.pwan("black"),1,5)
        game.board.put_piece(game.board.pwan("white"),1,3)
        game.board.put_piece(game.board.pwan("white"),2,4)
        expect(pwan.capturing_move([2,4], game.board_array, "black")).to eq([[1,5]])
    end
end

describe Bishop do
    let(:bishop) {Bishop.new("white")}
    let(:game) {Game.new}
    describe "#legal_move" do
        it "returns move bishop can make" do
            expect(bishop.legal_move([2,2],game.board_array)).to eq([
                [3,3],[4,4],[5,5],[6,6],[7,7],
                [3,1],[4,0],
                [1,3],[0,4],
                [1,1],[0,0]
            ])
        end
        it "returns move of bishop while considering piece on the way" do
            game.board.initial_position
            expect(bishop.legal_move([0,0], game.board_array)).to be_empty
        end
    end

    describe "#capturing_move" do
        it "return the location that it can capture" do
            game.board.put_piece(game.board.pwan("white"),1,3)
            expect(bishop.capturing_move([2,2], game.board_array, "white")).to eq([[1,3]])
        end

        it "return multiple location it can capture while ignoring same color" do
            game.board.put_piece(game.board.pwan("white"),3,3)
            game.board.put_piece(game.board.pwan("white"),3,1)
            game.board.put_piece(game.board.pwan("white"),4,0)
            game.board.put_piece(game.board.pwan("black"),1,1)
            game.board.put_piece(game.board.pwan("white"),0,0)
            expect(bishop.capturing_move([2,2], game.board_array, "white")).to eq([[3,3],[3,1]])
        end
    end
end

describe Knight do
    let(:knight) {Knight.new("white")}
    let(:game) {Game.new}
    describe "#legal_move" do
        it "returns the move knight can make" do
            expect(knight.legal_move([2,2],game.board_array)).to eq([
                [1,0],[3,4],[1,4],[3,0],[0,1],[4,3],[0,3],[4,1]
            ])
        end

        it "returns the move knight can make considering obstacle piece" do
            game.board.initial_position
            expect(knight.legal_move([0,1],game.board_array)).to eq([
                [2,2],[2,0]
            ])
        end
    end
end
