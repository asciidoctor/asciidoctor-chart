# frozen_string_literal: true

module Asciidoctor
  module Chart
    class PlainRubyRandom
      def self.uuid
        (0...8).map { (65 + (rand 26)).chr }.join
      end
    end
  end
end
