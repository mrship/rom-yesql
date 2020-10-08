# frozen_string_literal: true

require 'bundler'
Bundler.setup

if RUBY_ENGINE == 'ruby' && ENV['COVERAGE'] == 'true'
  require 'yaml'
  rubies = YAML.safe_load(File.read(File.join(__dir__, '..', '.travis.yml')))['rvm']
  latest_mri = rubies.select { |v| v =~ /\A\d+\.\d+.\d+\z/ }.max

  if RUBY_VERSION == latest_mri
    require 'simplecov'
    SimpleCov.start do
      add_filter '/spec/'
    end
  end
end

require 'rom-yesql'
require 'inflecto'
require 'logger'

begin
  require 'byebug'
rescue LoadError
end

LOGGER = Logger.new(File.open('./log/test.log', 'a'))

root = Pathname(__FILE__).dirname

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.warnings = true
end

Dir[root.join('shared/*.rb').to_s].sort.each { |f| require f }
