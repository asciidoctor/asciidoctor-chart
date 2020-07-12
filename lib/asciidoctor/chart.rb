# frozen_string_literal: true

require 'asciidoctor/extensions'
require_relative 'chart/block_macro'
require_relative 'chart/block'
require_relative 'chart/docinfo_processor'
require_relative 'chart/backend'
require_relative 'chart/plain_ruby_csv'
require_relative 'chart/plain_ruby_random'
require_relative 'chart/c3js/chart_builder'
require_relative 'chart/chartjs/chart_builder'
require_relative 'chart/chartist/chart_builder'

Asciidoctor::Extensions.register do
  return unless document.basebackend? 'html'
  block_macro Asciidoctor::Chart::BlockMacro
  block Asciidoctor::Chart::BlockProcessor
  docinfo_processor Asciidoctor::Chart::DocinfoProcessor
end
