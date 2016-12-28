# Rspec matchers for RxRuby observables

## Rationale

The asynchronous nature of RxRuby makes it hard to write good specs for code that returns observables. The complexity of next/error/completed notifications can also easily trip up a naive spec.

## Goal

The goal of rx-rspec is to provide powerful matchers that lets you express your expectations in a traditional rspec-like synchronous manner.

Currently, the ambition of this project is simply to support the use cases that I encounter in my own usage of RxRuby. Your pull requests are wellcome.

## Usage

rx-rspec is available from http://rubygems.org:
```
gem install rx-rspec
```

Once installed, you can use it to assert on your observables:
```
require 'rx'
require 'rx-rspec'

describe 'awesome' do
  subject { Rx::Observable.just(42) }
  it { should emit_exactly(42) }
end
```
