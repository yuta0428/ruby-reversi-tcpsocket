# frozen_string_literal: true

require 'spec_helper'
require './app/models/board'
require './app/controllers/board_controller'

describe BoardController do
  before do
    @len = 4
    @obj = BoardController.new(board)
  end

  let(:board) { Board.new(@len) }

  it 'is valid Wall' do
    expect(@obj.get_cell_with_xy(0, 0)).to be_an_instance_of Wall
    expect(@obj.get_cell_with_xy(0, 1)).to be_an_instance_of Wall
    expect(@obj.get_cell_with_xy(5, 1)).to be_an_instance_of Wall
    expect(@obj.get_cell_with_xy(5, 5)).to be_an_instance_of Wall
  end

  it 'is valid Empty' do
    expect(@obj.get_cell_with_xy(1, 1)).to be_an_instance_of Empty
  end

  it 'is valid Piece center' do
    p = @obj.get_cell_with_xy(2, 2)
    expect(p).to be_an_instance_of Piece
    expect(p.color).to eq Piece::WHITE

    p = @obj.get_cell_with_xy(3, 3)
    expect(p).to be_an_instance_of Piece
    expect(p.color).to eq Piece::WHITE

    p = @obj.get_cell_with_xy(3, 2)
    expect(p).to be_an_instance_of Piece
    expect(p.color).to eq Piece::BLACK

    p = @obj.get_cell_with_xy(2, 3)
    expect(p).to be_an_instance_of Piece
    expect(p.color).to eq Piece::BLACK
  end

  context 'is valid set Piece' do
    let(:board) { Board.new(@len) }
    let(:piece) { Piece.new(Piece::BLACK) }
    it 'is not able to set Piece on Wall' do
      expect(@obj.try_set_cell_with_xy!(0, 0, piece)).to eq false
    end

    it 'is not able to set Piece on Piece' do
      expect(@obj.try_set_cell_with_xy!(2, 2, piece)).to eq false
    end

    it 'is able to set Piece at condition' do
      expect(@obj.try_set_cell_with_xy!(2, 1, piece)).to eq true
      expect(@obj.get_cell_with_xy(2, 1)).to be_an_instance_of Piece
    end
  end

  context 'is valid flip up, down, right, left' do
    let(:board) { Board.new(@len) }
    it 'is flip_cell_indexes_with_dir down' do
      expect(@obj.flip_cell_indexes_with_dir(2, 1, Piece::BLACK, 0, 1)).to eq [14]
      expect(@obj.flip_cell_indexes_with_dir(2, 1, Piece::WHITE, 0, 1)).to eq []
    end
    it 'is flip_cell_indexes_with_dir up' do
      expect(@obj.flip_cell_indexes_with_dir(2, 4, Piece::BLACK, 0, -1)).to eq []
      expect(@obj.flip_cell_indexes_with_dir(2, 4, Piece::WHITE, 0, -1)).to eq [20]
    end
    it 'is flip_cell_indexes_with_dir right' do
      expect(@obj.flip_cell_indexes_with_dir(1, 2, Piece::BLACK, 1, 0)).to eq [14]
      expect(@obj.flip_cell_indexes_with_dir(1, 2, Piece::WHITE, 1, 0)).to eq []
    end
    it 'is flip_cell_indexes_with_dir left' do
      expect(@obj.flip_cell_indexes_with_dir(4, 2, Piece::BLACK, -1, 0)).to eq []
      expect(@obj.flip_cell_indexes_with_dir(4, 2, Piece::WHITE, -1, 0)).to eq [15]
    end
  end

  context 'is valid flip up right&left, down right&left' do
    let(:board) do
      b = Board.new(@len)
      b.set_cell_with_xy!(2, 2, Piece.new(Piece::BLACK))
      b.set_cell_with_xy!(2, 3, Piece.new(Piece::BLACK))
      b.set_cell_with_xy!(2, 4, Piece.new(Piece::BLACK))
      b.set_cell_with_xy!(3, 2, Piece.new(Piece::WHITE))
      b.set_cell_with_xy!(3, 3, Piece.new(Piece::WHITE))
      b.set_cell_with_xy!(3, 4, Piece.new(Piece::WHITE))
      b
    end
    it 'is flip_cell_indexes_with_dir up_right' do
      expect(@obj.flip_cell_indexes_with_dir(1, 4, Piece::BLACK, 1, -1)).to eq []
      expect(@obj.flip_cell_indexes_with_dir(1, 4, Piece::WHITE, 1, -1)).to eq [20]
    end
    it 'is flip_cell_indexes_with_dir up_left' do
      expect(@obj.flip_cell_indexes_with_dir(4, 4, Piece::BLACK, -1, -1)).to eq [21]
      expect(@obj.flip_cell_indexes_with_dir(4, 4, Piece::WHITE, -1, -1)).to eq []
    end
    it 'is flip_cell_indexes_with_dir down_right' do
      expect(@obj.flip_cell_indexes_with_dir(1, 1, Piece::BLACK, 1, 1)).to eq []
      expect(@obj.flip_cell_indexes_with_dir(1, 1, Piece::WHITE, 1, 1)).to eq [14]
    end
    it 'is flip_cell_indexes_with_dir down_left' do
      expect(@obj.flip_cell_indexes_with_dir(4, 1, Piece::BLACK, -1, 1)).to eq [15]
      expect(@obj.flip_cell_indexes_with_dir(4, 1, Piece::WHITE, -1, 1)).to eq []
    end
  end

  context 'is not able flip' do
    let(:board) do
      b = Board.new(@len)
      b.set_cell_with_xy!(2, 2, Piece.new(Piece::BLACK))
      b.set_cell_with_xy!(2, 3, Piece.new(Piece::BLACK))
      b.set_cell_with_xy!(2, 4, Piece.new(Piece::BLACK))
      b.set_cell_with_xy!(3, 2, Piece.new(Piece::WHITE))
      b.set_cell_with_xy!(3, 3, Piece.new(Piece::WHITE))
      b.set_cell_with_xy!(3, 4, Piece.new(Piece::WHITE))
      b
    end
    it 'is flip_cell_indexes_with_dir' do
      expect(@obj.flip_cell_indexes_with_dir(2, 1, Piece::WHITE, 0, 1)).to eq []
      expect(@obj.flip_cell_indexes_with_dir(3, 1, Piece::BLACK, 0, 1)).to eq []
    end
  end

  context 'is valid try_set_cell_with_xy' do
    let(:board) { Board.new(@len) }
    it 'is try_set_cell_with_xy' do
      expect(@obj.get_cell_with_xy(2, 3).color).to eq Piece::BLACK
      @obj.try_set_cell_with_xy!(2, 4, Piece.new(Piece::WHITE))
      expect(@obj.get_cell_with_xy(2, 3).color).to eq Piece::WHITE
    end
  end
end
