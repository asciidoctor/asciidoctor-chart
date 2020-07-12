# frozen_string_literal: true

module Asciidoctor
  module Chart
    class DocinfoProcessor < ::Asciidoctor::Extensions::DocinfoProcessor
      use_dsl
      #at_location :head

      C3JS_STYLESHEET = '<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.css">'
      D3JS_SCRIPT = '<script src="http://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js" charset="utf-8"></script>'
      C3JS_SCRIPT = '<script src="http://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.js"></script>'

      CHARTIST_STYLESHEET = '<link rel="stylesheet" href="http://cdn.jsdelivr.net/chartist.js/latest/chartist.min.css">'
      CHARTIST_SCRIPT = '<script src="http://cdn.jsdelivr.net/chartist.js/latest/chartist.min.js"></script>'

      CHARTJS_SCRIPT = '<script src="http://cdnjs.cloudflare.com/ajax/libs/Chart.js/1.0.2/Chart.min.js"></script>'

      def process doc
        # TODO Import only the required engines
        # TODO Honor linkcss and copycss
        <<~EOS
        #{C3JS_STYLESHEET}
        #{D3JS_SCRIPT}
        #{C3JS_SCRIPT}
        #{CHARTIST_STYLESHEET}
        #{CHARTIST_SCRIPT}
        #{CHARTJS_SCRIPT})
        EOS
      end
    end
  end
end
