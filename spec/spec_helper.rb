# frozen_string_literal: true

TEST_DIR = File.absolute_path __dir__

module Spec
  module Helpers
    def testdir
      TEST_DIR
    end

    def fixturedir
      File.join testdir, 'fixtures'
    end

    def fixture_path name
      File.join fixturedir, name
    end
  end
end

RSpec.configure do |config|
  config.include Spec::Helpers
end
