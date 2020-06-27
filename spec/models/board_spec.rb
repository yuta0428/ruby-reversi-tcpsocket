# frozen_string_literal: true

require 'spec_helper'
require './app/models/board'

# index
# 00 01 02 03 04 05
# 06 07 08 09 10 11
# 12 13 14 15 16 17
# 18 19 20 21 22 23
# 24 25 26 27 28 29
# 30 31 32 33 34 35

# xy
# 00 10 20 30 40 50
# 01 11 21 31 41 51
# 02 12 22 32 42 52
# 03 13 23 33 43 53
# 04 14 24 34 44 54
# 05 15 25 35 45 55

describe Board do
  before do
    @len = 4
    @obj = Board.new(@len)
  end

  it 'is valid xy2index' do
    expect(@obj.xy2index(0, 0)).to eq 0
    expect(@obj.xy2index(1, 1)).to eq 7
    expect(@obj.xy2index(0, 2)).to eq 12
    expect(@obj.xy2index(2, 3)).to eq 20
    expect(@obj.xy2index(3, 1)).to eq 9
  end

  it 'is valid get_center_indexes' do
    expect(@obj.center_indexes).to eq [14, 15, 20, 21]
  end
end
