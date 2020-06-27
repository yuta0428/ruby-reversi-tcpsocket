# frozen_string_literal: true

module Parser
  class JsonParser
    require 'json'

    def self.serialize(hash)
      # hash.to_json
      JSON.generate(hash)
    end

    def self.deserialize(json)
      JSON.parse(json, symbolize_names: true)
    end
  end
end
