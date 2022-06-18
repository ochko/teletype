# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc 'Run tests'
task default: :test

desc 'Testing usage for fast iteration'
task :usage do
  puts 'gem uninstall teletype -x'
  puts `gem uninstall teletype -x`

  puts 'gem build teletype.gemspec'
  puts `gem build teletype.gemspec`

  puts 'gem install teletype-*.gem --no-ri --no-rdoc'
  puts `gem install teletype-*.gem --no-ri --no-rdoc`

  puts 'teletype numbers'
  puts `teletype ruby`

  `rm -f teletype-*.gem`
end
