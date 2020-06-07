# frozen_string_literal: true

require 'spec_helper'
require './app/systems/parser'

describe Parser do
  context 'Json' do
    let(:hash) do
      {
        header: 'join',
        param: {
          name: 'yy'
        }
      }
    end
    let(:json) do
      '{"header":"join","param":{"name":"yy"}}'
    end
    it 'is valid serialize' do
      expect(Parser::JsonParser.serialize(hash)).to eq json
    end
    it 'is valid deserialize' do
      expect(Parser::JsonParser.deserialize(json)).to eq hash
    end
  end
end
