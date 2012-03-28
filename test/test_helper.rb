module Aides
  module Helpers
    def Helpers.load_fixture(name)
      dirname = File.dirname(__FILE__)
      File.read("#{dirname}/fixtures/#{name}")
    end
  end
end
