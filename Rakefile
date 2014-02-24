require "bundler/gem_tasks"

require 'rake/testtask'
Rake::TestTask.new('test:unit') do |t|
  t.test_files = FileList['test/*_test.rb']
end

task :default => :test

task :test => ['test:unit']
