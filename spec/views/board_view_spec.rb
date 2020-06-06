# frozen_string_literal: true

require 'spec_helper'
require './app/views/board_view'

describe BoardView do
  before do
    @len = 4
    @obj = BoardView.new(@len)
  end

  let(:wa) { BoardView::WALL.mark }
  let(:em) { BoardView::EMPTY.mark }
  let(:pw) { BoardView::WHITE.mark }
  let(:pb) { BoardView::BLACK.mark }

  it 'is valid render' do
    v = <<-EOS.chomp
   0 1 2 3 4 5
 0#{ [wa,wa,wa,wa,wa,wa].join }
 1#{ [wa,em,em,em,em,wa].join }
 2#{ [wa,em,pw,pb,em,wa].join }
 3#{ [wa,em,pb,pw,em,wa].join }
 4#{ [wa,em,em,em,em,wa].join }
 5#{ [wa,wa,wa,wa,wa,wa].join }
    EOS
    l = [
      -1,-1,-1,-1,-1,-1,
      -1, 0, 0, 0, 0,-1,
      -1, 0, 1, 2, 0,-1,
      -1, 0, 2, 1, 0,-1,
      -1, 0, 0, 0, 0,-1,
      -1,-1,-1,-1,-1,-1,
    ]
    expect(@obj.render(l)).to eq v
  end
end
