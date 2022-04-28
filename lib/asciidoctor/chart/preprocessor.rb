# frozen_string_literal: true

module Asciidoctor
  module Chart
    class Preprocessor < Asciidoctor::Extensions::Preprocessor
      def process document, reader
        document.extend(ChartBlockTracker)

        reader
      end
    end
  end
end
