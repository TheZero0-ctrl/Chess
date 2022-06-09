require_relative "../lib/board"
require_relative "../lib/display"
require_relative "../lib/cell"
require_relative "../lib/game"

describe Board do
    let(:board){Board.new}
    describe "#assign_color_to_cell" do
        it "returns white" do
            expect(board.assign_color_to_cell[0][0].color).to eq("white")
        end
        it "returns black" do
            expect(board.assign_color_to_cell[0][1].color).to eq("black")
        end
        it "returns black" do
            expect(board.assign_color_to_cell[2][3].color).to eq("black")
        end
        it "returns black" do
            expect(board.assign_color_to_cell[7][0].color).to eq("black")
        end
        it "returns white" do
            expect(board.assign_color_to_cell[4][4].color).to eq("white")
        end
        it "returns white" do
            expect(board.assign_color_to_cell[7][7].color).to eq("white")
        end
    end
end