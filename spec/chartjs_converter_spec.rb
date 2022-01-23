# frozen_string_literal: true

require 'asciidoctor'
require_relative '../lib/asciidoctor-chart'

describe 'Asciidoctor::Chart::Converter::Html5ChartjsConverter' do
  chartjs_converter = Asciidoctor::Chart::Converter::Html5ChartjsConverter.new
  doc = Asciidoctor.load('')
  data = [
    %w[January February March April May June July],
    [28, 48, 40, 19, 86, 27, 90],
    [65, 59, 80, 81, 56, 55, 40]
  ]
  it 'should use px unit when no unit is defined' do
    node = Asciidoctor::Chart::ChartBlock.new doc, data, {
      'width' => '600',
      'height' => '400'
    }
    html = chartjs_converter.convert_line_chart node
    (expect html).to include %(<div class="content chartjs-content" style="height: 400px; max-width: 600px">)
  end
  it 'should preserve units when defined on width or height' do
    node = Asciidoctor::Chart::ChartBlock.new doc, data, {
      'width' => '80%',
      'height' => '20vh'
    }
    html = chartjs_converter.convert_line_chart node
    (expect html).to include %(<div class="content chartjs-content" style="height: 20vh; max-width: 80%">)
  end
  it 'should disable maintain aspect ratio when width or height is defined' do
    node = Asciidoctor::Chart::ChartBlock.new doc, data, { 'width' => '600' }
    html = chartjs_converter.convert_line_chart node
    (expect html).to include 'maintainAspectRatio: false'

    node = Asciidoctor::Chart::ChartBlock.new doc, data, { 'width' => '400' }
    html = chartjs_converter.convert_line_chart node
    (expect html).to include 'maintainAspectRatio: false'
  end
end
