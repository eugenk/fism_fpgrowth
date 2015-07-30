require 'bundler/setup'
Bundler.setup

require 'fism_fpgrowth'

RSpec.configure do |config|
  config.before(:suite) do
    if !File.exist?(File.expand_path('../../vendor/fpgrowth/src/fpgrowth',
                                     __FILE__))
      Dir.chdir(File.expand_path('../..', __FILE__)) do
        system('make')
      end
    end
  end
end
