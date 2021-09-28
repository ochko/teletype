Gem::Specification.new do |s|
  s.name          = "teletype"
  s.version       = "0.0.0"
  s.authors       = ["Ochirkhuyag Lkhagva"]
  s.email         = ["ochkoo@gmail.com"]
  s.summary       = "Typing practice on command line."
  s.description   = "It trains you typing skills with targeted lessons and your preferred text content."
  s.homepage      = "https://github.com/ochko/teletype"
  s.license       = "MIT"

  s.files         = Dir['tty-reader.gemspec', 'README.md', 'LICENSE.txt', 'Rakefile']
  s.files        += Dir['{lib,bin,test}/**/*.rb']
  s.executables   << "teletype"

  s.required_ruby_version = '>= 2.7.0'

  s.add_development_dependency 'rake', '~> 13.0', '> 13.0.0'
end
