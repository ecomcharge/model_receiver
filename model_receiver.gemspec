# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "model_receiver"
  s.version     = "0.0.1"
  s.authors     = ["Mikhail Davidovich"]
  s.email       = ["mihaildv@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "model_receiver"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<sinatra>, [">= 1.3"])
  s.add_runtime_dependency(%q<rack-contrib>, [">= 0"])
  s.add_runtime_dependency(%q<activesupport>, [">=0"])
  s.add_development_dependency(%q<rspec>, [">= 2.14.1"])
  s.add_development_dependency(%q<debugger>, [">= 1.6.2"])
  s.add_development_dependency(%q<rack-test>, [">=0"])
end
