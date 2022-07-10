# frozen_string_literal: true

module Asciidoctor
  module Chart
    class DocinfoProcessor < ::Asciidoctor::Extensions::DocinfoProcessor
      use_dsl
      # at_location :head

      C3JS_DIR_ATTR = 'c3jsdir'
      C3JS_DEFAULT_PATH = 'https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/'

      CHARTJS_DIR_ATTR = 'chartjsdir'
      CHARTJS_DEFAULT_PATH = 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/'

      CHARTIST_DIR_ATTR = 'chartistdir'
      CHARTIST_DEFAULT_PATH = 'https://cdn.jsdelivr.net/npm/chartist@0.11.x/dist/'

      D3JS_DIR_ATTR = 'd3jsdir'
      D3JS_DEFAULT_PATH = 'https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/'

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

      def process(doc)
        engines = doc.x_chart[:engines]
        (engines.map {|engine| send(engine, doc) }.to_a + [DEFAULT_STYLE]).join "\n"
      end

      private

      def get_path(doc, attr_name, default_path, asset_to_include)
        doc.normalize_web_path asset_to_include, (doc.attr attr_name, default_path), false
      end

      def create_script_directive(doc, attr_name, default_path, asset_to_include)
        %(<script src="#{get_path doc, attr_name, default_path, asset_to_include}"></script>)
      end

      def create_link_css_directive(doc, attr_name, default_path, asset_to_include)
        %(<link rel="stylesheet" href="#{get_path doc, attr_name, default_path, asset_to_include}">)
      end

      def chartjs(doc)
        create_script_directive(doc, CHARTJS_DIR_ATTR, CHARTJS_DEFAULT_PATH, 'chart.min.js')
      end

      def chartist(doc)
        result = []
        result << create_link_css_directive(doc, CHARTIST_DIR_ATTR, CHARTIST_DEFAULT_PATH, 'chartist.min.css')
        result << create_script_directive(doc, CHARTIST_DIR_ATTR, CHARTIST_DEFAULT_PATH, 'chartist.min.js')
        result
      end

      def c3js(doc)
        result = []
        result << create_link_css_directive(doc, C3JS_DIR_ATTR, C3JS_DEFAULT_PATH, 'c3.min.css')
        result << create_script_directive(doc, D3JS_DIR_ATTR, D3JS_DEFAULT_PATH, 'd3.min.js')
        result << create_script_directive(doc, C3JS_DIR_ATTR, C3JS_DEFAULT_PATH, 'c3.min.js')
        result
      end
    end
  end
end
