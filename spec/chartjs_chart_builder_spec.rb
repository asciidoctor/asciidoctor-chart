# frozen_string_literal: true

require 'asciidoctor'
require_relative '../lib/asciidoctor-chart'

describe 'Asciidoctor::Chart::Chartjs::ChartBuilder' do
  it 'should use px unit when no unit is defined' do
    data = [
      [28, 48, 40, 19, 86, 27, 90],
      [65, 59, 80, 81, 56, 55, 40]
    ]
    labels = %w[January February March April May June July]
    attrs = {
      'width' => '600',
      'height' => '400'
    }
    html = Asciidoctor::Chart::Chartjs::ChartBuilder.line data, labels, attrs
    (expect html).to include %(<div class="chartjs-container" style="position: relative; height: 400px; width: 600px">)
  end
  it 'should preserve units when defined on width or height' do
    data = [
      [28, 48, 40, 19, 86, 27, 90],
      [65, 59, 80, 81, 56, 55, 40]
    ]
    labels = %w[January February March April May June July]
    attrs = {
      'width' => '80%',
      'height' => '20vh'
    }
    html = Asciidoctor::Chart::Chartjs::ChartBuilder.line data, labels, attrs
    (expect html).to include %(<div class="chartjs-container" style="position: relative; height: 20vh; width: 80%">)
  end
  it 'should disable maintain aspect ratio when width or height is defined' do
    data = [
      [28, 48, 40, 19, 86, 27, 90],
      [65, 59, 80, 81, 56, 55, 40]
    ]
    labels = %w[January February March April May June July]
    html = Asciidoctor::Chart::Chartjs::ChartBuilder.line data, labels, { 'width' => '600' }
    (expect html).to include 'maintainAspectRatio: false'

    html = Asciidoctor::Chart::Chartjs::ChartBuilder.line data, labels, { 'height' => '400' }
    (expect html).to include 'maintainAspectRatio: false'
  end
end
