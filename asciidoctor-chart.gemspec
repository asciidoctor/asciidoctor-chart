# frozen_string_literal: true

begin
  require_relative 'lib/asciidoctor/chart/version'
rescue LoadError
  require 'asciidoctor/chart/version'
end

Gem::Specification.new do |s|
  s.name = 'asciidoctor-chart'
  s.version = Asciidoctor::Chart::VERSION
  s.summary = 'Adds a chart block and block macro to AsciiDoc'
  s.description = "A set of Asciidoctor extensions that add a chart block and block macro to AsciiDoc
for including charts in your AsciiDoc document."
  s.authors = ['Guillaume Grossetie']
  s.email = 'ggrossetie@gmail.com'
  s.homepage = 'https://asciidoctor.org'
  s.license = 'MIT'
  # NOTE: required ruby version is informational only;
  # it's not enforced since it can't be overridden and can cause builds to break
  # s.required_ruby_version = '>= 2.7.0'
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/asciidoctor/asciidoctor-chart/issues',
    # 'changelog_uri' => 'https://github.com/asciidoctor/asciidoctor-chart/blob/master/CHANGELOG.adoc',
    'community_chat_uri' => 'https://asciidoctor.zulipchat.com',
    'source_code_uri' => 'https://github.com/asciidoctor/asciidoctor-chart',
    'rubygems_mfa_required' => 'true'
  }

  # NOTE: the logic to build the list of files is designed to produce a usable package
  # even when the git command is not available
  begin
    files = (result = `git ls-files -z`.split "\0").empty? ? Dir['**/*'] : result
  rescue StandardError
    files = Dir['**/*']
  end
  s.files = files.grep %r{^(?:(?:data|lib)/.+|(?:CHANGELOG|LICENSE|NOTICE|README)\.adoc|\.yardopts|#{s.name}\.gemspec)$}
  s.executables = (files.grep %r{^bin/}).map {|f| File.basename f }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'asciidoctor', '~> 2.0'
  s.add_runtime_dependency 'tilt', '~> 2.0.0'
  s.add_development_dependency 'rake', '~> 13.0.0'
  s.add_development_dependency 'rspec', '~> 3.9.0'
end
