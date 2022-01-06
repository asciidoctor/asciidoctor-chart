# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Registry
      @registry = {}

      def self.register converter, engine
        @registry[engine] = converter
      end

      def self.for engine
        @registry[engine]
      end
    end
  end
end
