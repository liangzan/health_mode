Gem::Specification.new do |s|
  s.name = "health_mode"
  s.version = "0.1.3"
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = "Health mode exposes system health metrics via an api"
  s.homepage = "http://github.com/liangzan/health_mode"
  s.email = "zan@liangzan.net"
  s.authors = [ "Wong Liang Zan" ]

  s.files = %w( README.md Rakefile LICENSE CHANGELOG.md )
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("bin/**/*")
  s.files += Dir.glob("test/**/*")
  s.executables = [ "health-mode-agent" ]

  s.extra_rdoc_files = [ "LICENSE", "README.md" ]
  s.rdoc_options = ["--charset=UTF-8"]

  s.add_dependency 'sinatra', '~> 1.3.1'
  s.add_dependency 'json', '~>1.6.1'
  s.add_dependency 'thin', '~>1.3.1'
  s.add_dependency 'vegas', '~>0.1.8'
  s.add_dependency 'rake'

  s.description = "Health mode exposes the system metrics via a JSON api. This opens the door for integration with web services. "
end
