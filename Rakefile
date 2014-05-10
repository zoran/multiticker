#!/usr/bin/env rake

require "rake/testtask"
require "pry"

Dir[File.join('lib', 'tasks', '**', '*.rake')].each do |file|
  import file
end

task :console do
  binding.pry
end

namespace :test do
  Rake::TestTask.new("all") do |t|
    t.name    = "all"
    t.pattern = "test/**/*_{spec,test}.rb"
  end

  Rake::TestTask.new("unit") do |t|
    t.name    = "unit"
    t.pattern = "test/unit/**/*_{spec,test}.rb"
  end

  Rake::TestTask.new("functional") do |t|
    t.name    = "functional"
    t.pattern = "test/functional/**/*_{spec,test}.rb"
  end

  Rake::TestTask.new("integration") do |t|
    t.name    = "integration"
    t.pattern = "test/integration/**/*_{spec,test}.rb"
  end
end

namespace :test do
  desc "Generate coverage report"
  task :coverage do
    rm_rf "test/coverage"
    task = Rake::Task["test:all"]
    task.reenable
    task.invoke
  end
end

desc "List all available rake tasks"
task :help do
  system("rake -T")
end

task :test do
  system("rake COVERAGE=true test:all")
end

# Set 'rake help' as default task
task default: :help
