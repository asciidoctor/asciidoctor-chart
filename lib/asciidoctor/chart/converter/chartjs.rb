# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Converter
      class Html5ChartjsConverter < Asciidoctor::Chart::Converter::Base
        CSS_VALUE_UNIT_RX = /^([+-]?(?:\d+|\d*\.\d+))([a-z]*|%)$/.freeze
        DEFAULT_COLORS = [{ r: 220, g: 220, b: 220 }, { r: 151, g: 187, b: 205 }].freeze

        def convert_line_chart node
          data, labels = prepare_data node
          datasets = data.map do |set|
            color = DEFAULT_COLORS[data.index(set) % 2]
            color_rgba = "rgba(#{color[:r]},#{color[:g]},#{color[:b]},1.0)"
            <<~JSON
              {
                borderColor: "#{color_rgba}",
                backgroundColor: "#{color_rgba}",
                fill: false,
                tension: 0.1,
                data: #{set.to_s}
              }
            JSON
          end.join ','

          chart_id = node.attr 'id'
          inline_styles = []
          if (chart_height = get_height node)
            inline_styles.push("height: #{chart_height}")
          end
          if (chart_width = get_width node)
            inline_styles.push("max-width: #{chart_width}")
          end
          maintain_aspect_ratio = chart_height.nil? && chart_width.nil?
          title_element = node.title? ? %(\n  <div class="title">#{node.captioned_title}</div>) : ''
          <<~HTML
            <div class="chartblock">
              <div class="content chartjs-content" style="#{inline_styles.join('; ')}">
                <canvas id="#{chart_id}"></canvas>
              </div>#{title_element}
            </div>
            <script>
            window.addEventListener('load', function(event) {
              var data = {
                labels: #{labels.to_s},
                datasets: [#{datasets}]
              }
              var chart = new Chart(document.getElementById("#{chart_id}").getContext("2d"), {
                type: 'line',
                data: data,
                options: {
                  interaction: {
                    mode: 'index'
                  },
                  responsive : true,
                  maintainAspectRatio: #{maintain_aspect_ratio},
                  plugins: {
                    legend: {
                      display: false
                    }
                  }
                }
              })
            })
            </script>
          HTML
        end

        def prepare_data node
          raw_data = node.attr 'data-raw', []
          return [[], []] if raw_data.length <= 1 # question: should we warn?

          labels = raw_data[0]
          raw_data.shift
          [raw_data, labels]
        end

        private

        def get_height node
          return unless (height = node.attr 'height')

          to_css_size height
        end

        def get_width node
          return unless (width = node.attr 'width')

          to_css_size width
        end

        def to_css_size str
          return str unless (parts = str.match(CSS_VALUE_UNIT_RX))

          value, unit = parts.captures
          unit = 'px' if unit == ''
          "#{value}#{unit}"
        end
      end
    end
  end
end
