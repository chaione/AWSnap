# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "awsnap/version"

Gem::Specification.new do |s|
  s.name        = "awsnap"
  s.version     = Awsnap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Scott Burton"]
  s.email       = ["scott.burton@chaione.com"]
  s.homepage    = "http://www.chaione.com"
  s.summary     = %q{AWSnap signs your AWS requests for you.}
  s.description = %q{AWSnap signs your AWS requests for you. No request processing, no response handling, no extra nonsense. Works for all AWS endpoints.}

  s.rubyforge_project = "awsnap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency("activesupport")
end
