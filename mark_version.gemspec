Gem::Specification.new do |s|
  s.name = 'mark_version'
  s.version = '0.0.0'
  s.date = '2015-05-30'
  s.summary = 'A tool for recording the version of a ruby application.'
  s.authors = ['Grayden Smith']
  s.email = 'grayden@tech-vision.ca'
  s.files = `git ls-files`.split($/)
  s.homepage = 'http://graydens.ca'
  s.license = 'MIT'

  s.add_development_dependency 'rspec', '~> 3.2'
end
