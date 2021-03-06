# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "semver_stringer/version"

Gem::Specification.new do |s|
  s.name        = "semver_stringer"
  s.version     = SemverStringer::VERSION
  s.authors     = ["Ian Truslove"]
  s.email       = ["ian.truslove@gmail.com"]
  s.homepage    = "https://github.com/iantruslove/SemverStringer"
  s.summary     = %q{Makes nice strings for your SemVer needs}
  s.description = %q{See semver.org for the rules, or https://github.com/iantruslove/SemverStringer#readme for a little documentation.}

#  s.rubyforge_project = "semverstringer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  s.add_development_dependency "rspec", "~> 2.8"
end
