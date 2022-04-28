# frozen_string_literal: true

module Asciidoctor
  module Chart
    class DocinfoProcessor < ::Asciidoctor::Extensions::DocinfoProcessor
      use_dsl
      # at_location :head

      ASSETS = {
        c3js: <<~HTML.chomp,
          <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.css">
          <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js" charset="utf-8"></script>
          <script src="https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.js"></script>
        HTML
        chartist: <<~HTML.chomp,
          <link rel="stylesheet" href="https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.css">
          <script src="https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.js"></script>
        HTML
        chartjs: <<~HTML.chomp
          <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
        HTML
      }.freeze

      DEFAULT_STYLE = <<~HTML.chomp
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
      HTML

      def process doc
        engines = doc.x_chart[:engines]
        (engines.map {|engine| ASSETS[engine.to_sym] }.to_a + [DEFAULT_STYLE]).join("\n")
      end
    end
  end
end
