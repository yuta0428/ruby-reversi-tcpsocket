# frozen_string_literal: true

require 'spec_helper'
require './app/models/board'

# 00 01 02 03 04 05
# 06 07 08 09 10 11
# 12 13 14 15 16 17
# 18 19 20 21 22 23
# 24 25 26 27 28 29
# 30 31 32 33 34 35

describe Board do
  before do
    @len = 4
    @obj = Board.new(@len)
  end

  it 'is valid xy2index' do
    expect(@obj.send(:xy2index, 0, 0)).to eq 7
    expect(@obj.send(:xy2index, 0, 2)).to eq 19
    expect(@obj.send(:xy2index, 2, 3)).to eq 27
    expect(@obj.send(:xy2index, 3, 1)).to eq 16
  end

  it 'is valid get_center_indexes' do
    expect(@obj.send(:center_indexes)).to eq [14, 15, 20, 21]
  end

  it 'is valid Wall' do
    expect(@obj.send(:get_block_with_index, 0)).to be_an_instance_of Wall
    expect(@obj.send(:get_block_with_index, 12)).to be_an_instance_of Wall
    expect(@obj.send(:get_block_with_index, 17)).to be_an_instance_of Wall
    expect(@obj.send(:get_block_with_index, 35)).to be_an_instance_of Wall
  end

  it 'is valid Empty' do
    expect(@obj.send(:get_block_with_index, 7)).to be_an_instance_of Empty
  end

  it 'is valid Piece' do
    p = @obj.send(:get_block_with_index, 14)
    expect(p).to be_an_instance_of Piece
    expect(p.color).to eq Piece::WHITE

    p = @obj.send(:get_block_with_index, 15)
    expect(p).to be_an_instance_of Piece
    expect(p.color).to eq Piece::BLACK
  end

  context 'is valid set Piece' do
    let(:obj) { @obj }
    let(:piece) { Piece.new(Piece::WHITE) }
    it 'is not able to set Piece' do
      expect(obj.send(:try_set_block_with_index!, 0, piece)).to eq false
      expect(obj.send(:try_set_block_with_index!, 14, piece)).to eq false
    end

    it 'is able to set Piece' do
      expect(obj.send(:try_set_block_with_index!, 10, piece)).to eq true
      expect(obj.send(:get_block_with_index, 10)).to be_an_instance_of Piece
    end
  end
end
