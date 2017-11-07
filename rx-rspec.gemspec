Gem::Specification.new do |spec|
  spec.name        = 'rx-rspec'
  spec.version     = '0.3.0'
  spec.summary     = 'rspec testing support for RxRuby'
  spec.description = 'Writing specs for reactive streams is tricky both because of their asynchronous nature and because their next/error/completed semantics. The goal of rx-rspec is to provide powerful matchers that lets you express your expectations in a traditional rspec-like synchronous manner.'
  spec.authors     = ['Anders Qvist']
  spec.email       = 'bittrance@gmail.com'
  spec.homepage    = 'http://github.org/bittrance/rx-rspec'
  spec.license     = 'MIT'

  spec.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(/^spec/) }

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'rx'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
