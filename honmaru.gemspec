
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'honmaru/version'

Gem::Specification.new do |spec|
  spec.name          = 'honmaru'
  spec.version       = Honmaru::VERSION
  spec.authors       = ['sinofseven']
  spec.email         = ['em.s.00001@gmail.com']

  spec.summary       = 'CLI Tool For AWS CloudFormation'
  spec.description   = 'CLI Tool For AWS CloudFormation'
  spec.homepage      = 'https://github.com/sinofseven/honmaru'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'aws-sdk-cloudformation', '~> 1.4.0'
  spec.add_runtime_dependency 'pastel', '~> 0.7.2'
  spec.add_runtime_dependency 'thor', '~> 0.20'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
