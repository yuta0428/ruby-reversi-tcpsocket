# frozen_string_literal: true

require 'spec_helper'
require './app/systems/request'

describe Request do
  before(:all) do
    Class1 = Struct.new(:visible, :pos, keyword_init: true)
    Class2 = Struct.new(:x, :y)
  end

  it 'is valid to_deep_hash single hash' do
    obj = Class2.new(1, 2)
    hash = { x: 1, y: 2 }
    expect(to_deep_hash(obj)).to eq hash
  end

  it 'is valid to_deep_hash nest hash' do
    obj = Class1.new(visible: true, pos: Class2.new(1, 2))
    hash = { visible: true, pos: { x: 1, y: 2 } }
    expect(to_deep_hash(obj)).to eq hash
  end

  it 'is valid Request.to_hash' do
    obj =
      Request.new(
        'header',
        Class1.new(
          visible: true,
          pos: Class2.new(1, 2)
        )
      )
    hash =
      {
        header: 'header',
        param: {
          visible: true,
          pos: {
            x: 1,
            y: 2
          }
        }
      }
    expect(obj.to_hash).to eq hash
  end

  it 'is valid Response.to_hash' do
    obj =
      Response.new(
        'header',
        Class1.new(
          visible: true,
          pos: Class2.new(1, 2)
        ),
        200
      )
    hash =
      {
        header: 'header',
        body: {
          visible: true,
          pos: {
            x: 1,
            y: 2
          }
        },
        status: 200
      }
    expect(obj.to_hash).to eq hash
  end
end
