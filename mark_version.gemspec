Gem::Specification.new do |s|
  s.name = 'mark_version'
  s.version = '0.1.0'
  s.date = '2015-05-30'
  s.summary = 'A tool for recording the version of a ruby application.'
  s.authors = ['Grayden Smith']
  s.email = 'grayden@tech-vision.ca'
  s.files = `git ls-files`.split($/)
  s.executables << 'version'
  s.homepage = 'http://graydens.ca'
  s.license = 'MIT'

  s.add_dependency 'json', '~> 1.8.2'

  s.add_development_dependency 'thor', '~> 0.19'
  s.add_development_dependency 'rspec', '~> 3.2'
end
