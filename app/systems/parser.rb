# frozen_string_literal: true

module Parser
  class JsonParser
    require 'json'

    def self.serialize(hash)
      hash.to_json
    end

    def self.deserialize(json)
      JSON.parse(json)
    end
  end
end
