# frozen_string_literal: true

require 'spec_helper'
require './app/models/board'
require './app/controllers/board_controller'

describe BoardController do
  before do
    @len = 4
    board = Board.new(@len)
    @obj = BoardController.new
    @obj.register_board(board)
  end

  it 'is valid Wall' do
    expect(@obj.get_pieace_with_xy(-1, -1)).to be_an_instance_of Wall
    expect(@obj.get_pieace_with_xy(-1, 1)).to be_an_instance_of Wall
    expect(@obj.get_pieace_with_xy(4, 1)).to be_an_instance_of Wall
    expect(@obj.get_pieace_with_xy(4, 4)).to be_an_instance_of Wall
  end

  it 'is valid Empty' do
    expect(@obj.get_pieace_with_xy(0, 0)).to be_an_instance_of Empty
  end

  it 'is valid Piece' do
    p = @obj.get_pieace_with_xy(1, 1)
    expect(p).to be_an_instance_of Piece
    expect(p.color).to eq Piece::WHITE

    p = @obj.get_pieace_with_xy(2, 2)
    expect(p).to be_an_instance_of Piece
    expect(p.color).to eq Piece::BLACK
  end

  context 'is valid set Piece' do
    let(:obj) { @obj }
    let(:piece) { Piece.new(Piece::WHITE) }
    it 'is not able to set Piece on Wall' do
      expect(obj.try_set_pieace_with_xy!(-1, -1, piece)).to eq false
    end

    it 'is not able to set Piece on Piece' do
      expect(obj.try_set_pieace_with_xy!(1, 1, piece)).to eq false
    end

    it 'is able to set Piece at condition' do
      expect(obj.try_set_pieace_with_xy!(3, 0, piece)).to eq true
      expect(obj.get_pieace_with_xy(3, 0)).to be_an_instance_of Piece
    end
  end
end
