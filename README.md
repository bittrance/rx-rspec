# Rspec matchers for RxRuby observables

[![Gem Version](https://badge.fury.io/rb/rx-rspec.svg)](https://badge.fury.io/rb/rx-rspec)
[![Build Status](https://travis-ci.org/bittrance/rx-rspec.svg?branch=master)](https://travis-ci.org/bittrance/rx-rspec)
[![Code Climate](https://codeclimate.com/github/bittrance/rx-rspec/badges/gpa.svg)](https://codeclimate.com/github/bittrance/rx-rspec)
[![Test Coverage](https://codeclimate.com/github/bittrance/rx-rspec/badges/coverage.svg)](https://codeclimate.com/github/bittrance/rx-rspec/coverage)

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
  subject { Rx::Observable.of(1, 2, 3) }
  it { should emit_exactly(1, 2, 3) }
end
```

## Matchers

rx-spec include the following matchers:

- **emit_exactly()** metches against all items produced by the observable and requires the observable to be completed.
- **emit_first()** matches against the first elements of the observable, but does not require it to complete
- **emit_include()** consumes elements until the expected elements have occurred
