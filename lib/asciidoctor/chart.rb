# frozen_string_literal: true

require 'asciidoctor/extensions'
require 'tilt'
require_relative 'chart/html5_chart_converter_ext'
require_relative 'chart/registry'
require_relative 'chart/block_macro_processor'
require_relative 'chart/block_processor'
require_relative 'chart/docinfo_processor'
require_relative 'chart/chart_block'
require_relative 'chart/plain_ruby_csv'
require_relative 'chart/plain_ruby_random'
require_relative 'chart/converter'
require_relative 'chart/converter/c3js'
require_relative 'chart/converter/chartist'
require_relative 'chart/converter/chartjs'

CHART_HTML_TEMPLATE = Tilt.new('chart.html.erb', format: :html5, pretty: true, disable_escape: true) do |_t|
  <<-ERB
    <%= Class.new.extend(Asciidoctor::Chart::Html5ChartConverterExt).convert_chart self %>
  ERB
end

# providers
Asciidoctor::Chart::Registry.register Asciidoctor::Chart::Converter::Html5ChartjsConverter.new, 'chartjs'
Asciidoctor::Chart::Registry.register Asciidoctor::Chart::Converter::Html5ChartistConverter.new, 'chartist'
Asciidoctor::Chart::Registry.register Asciidoctor::Chart::Converter::Html5C3jsConverter.new, 'c3js'

def register_chart_converter converter
  if (converter.instance_of? Asciidoctor::Converter::TemplateConverter) || (converter.respond_to? 'register')
    # Template based converter
    converter.register 'chart', CHART_HTML_TEMPLATE
  else
    converter.extend(Asciidoctor::Chart::Html5ChartConverterExt)
  end
end

Asciidoctor::Extensions.register do
  return unless document.basebackend? 'html'

  converter = document.converter
  if converter.instance_of? Asciidoctor::Converter::CompositeConverter
    register_chart_converter(converter.converters[0])
  else
    register_chart_converter(converter)
  end
  block_macro Asciidoctor::Chart::BlockMacroProcessor
  block Asciidoctor::Chart::BlockProcessor
  docinfo_processor Asciidoctor::Chart::DocinfoProcessor
end
