# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Chartjs

      CSS_VALUE_UNIT_RX = /^([+-]?(?:\d+|\d*\.\d+))([a-z]*|%)$/.freeze

      class ChartBuilder

        class << self
          def line data, labels, attrs
            default_colors = [{ r: 220, g: 220, b: 220 }, { r: 151, g: 187, b: 205 }]
            datasets = data.map do |set|
              color = default_colors[data.index(set) % 2]
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
            chart_id = attrs.fetch('id', "chart#{PlainRubyRandom.uuid}")
            inline_styles = ['position: relative']
            if (chart_height = get_height attrs)
              inline_styles.push("height: #{chart_height}")
            end
            if (chart_width = get_width attrs)
              inline_styles.push("width: #{chart_width}")
            end
            maintain_aspect_ratio = chart_height.nil? && chart_width.nil?
            <<~HTML
              <div style="#{inline_styles.join('; ')}"><canvas id="#{chart_id}"></canvas></div>
              <script>
              window.addEventListener('load', function(event) {
                var data = {
                  labels: #{labels.to_s},
                  datasets: [
                    #{datasets}
                  ]
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

          def prepare_data raw_data
            labels = raw_data[0]
            raw_data.shift
            [raw_data, labels]
          end

          private

          def get_height attrs
            return unless (height = (attrs.fetch 'height', nil))

            to_css_size height
          end

          def get_width attrs
            return unless (width = (attrs.fetch 'width', nil))

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
end
