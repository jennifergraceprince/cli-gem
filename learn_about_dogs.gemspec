
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "learn_about_dogs/version"

Gem::Specification.new do |spec|
  spec.name          = "learn_about_dogs"
  spec.version       = LearnAboutDogs::VERSION
  spec.authors       = ["Jennifer Prince"]
  spec.email         = ["jennifergraceprince@gmail.com"]

  spec.summary       = %q{A gem that helps the user learn about dogs.}
  spec.homepage      = "https://github.com/jennifergraceprince/cli-gem/learn_about_dogs"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables << 'learn_about_dogs'

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "nokogiri", ">= 1.8.5"
end
