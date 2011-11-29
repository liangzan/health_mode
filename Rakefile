require 'rubygems'
require 'rake'

def gemspec
  @gemspec ||= begin
    file = File.expand_path("../health_mode.gemspec", __FILE__)
    eval(File.read(file), binding, file)
  end
end

begin
  require 'rake/gempackagetask'
  Rake::GemPackageTask.new(gemspec) do |pkg|
    pkg.gem_spec = gemspec
  end
  task :gem => :gemspec
rescue LoadError
  task(:gem){abort "`gem install rake` to package gems"}
end

desc "Install the gem locally"
task :install => :gem do
  sh "gem install pkg/#{gemspec.full_name}.gem"
end

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

desc "Runs the tests"
task :test do
  sh "ruby test/health_mode_test.rb"
end
