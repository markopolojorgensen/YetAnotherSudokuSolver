# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sudoku/version'

Gem::Specification.new do |spec|
  spec.name          = 'sudoku'
  spec.version       = Sudoku::VERSION
  spec.authors       = ['Mark Jorgensen']
  spec.email         = ['jorge428@umn.edu']
  spec.summary       = 'Yet Another Sudoku Solver'
  spec.description   = 'Solves Sudoku puzzles'
  spec.homepage      = 'https://github.com/markopolojorgensen/YetAnotherSudokuSolver'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'colorize'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
end
