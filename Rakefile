require "bundler/gem_tasks"
require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new('test:unit') do |t|
  t.test_files = FileList['test/*_test.rb']
end

RuboCop::RakeTask.new

task default: [:test, :rubocop]

task test: ['test:unit']
