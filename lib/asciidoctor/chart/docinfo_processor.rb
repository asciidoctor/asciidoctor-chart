# frozen_string_literal: true

module Asciidoctor
  module Chart
    class DocinfoProcessor < ::Asciidoctor::Extensions::DocinfoProcessor
      use_dsl
      # at_location :head

      C3JS_STYLESHEET = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.css">'
      D3JS_SCRIPT = '<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js" charset="utf-8"></script>'
      C3JS_SCRIPT = '<script src="https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.js"></script>'

      CHARTIST_STYLESHEET = '<link rel="stylesheet" href="https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.css">'
      CHARTIST_SCRIPT = '<script src="https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.js"></script>'

      CHARTJS_SCRIPT = '<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>'

      def process _doc
        # TODO: Import only the required engines
        # TODO: Honor linkcss and copycss
        <<~EOS
        #{C3JS_STYLESHEET}
        #{D3JS_SCRIPT}
        #{C3JS_SCRIPT}
        #{CHARTIST_STYLESHEET}
        #{CHARTIST_SCRIPT}
        #{CHARTJS_SCRIPT}
        <style>
          .chartblock {
            margin-bottom: 1.25em;
          }
          .chartblock > .title {
            text-rendering: optimizeLegibility;
            text-align: left;
            font-size: 1rem;
            font-style: italic;
            line-height: 1.45;
            color: #7a2518;
            font-weight: 400;
          }
          .chartblock > .chartjs-content {
            position: relative;
            margin-bottom: 0.25em;
          }
        </style>
        EOS
      end
    end
  end
end
