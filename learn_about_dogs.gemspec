
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "learn_about_cats/version"

Gem::Specification.new do |spec|
  spec.name          = "learn_about_cats"
  spec.version       = LearnAboutCats::VERSION
  spec.authors       = ["Jennifer Prince"]
  spec.email         = ["jennifergraceprince@gmail.com"]

  spec.summary       = %q{A gem that helps the user learn about cats.}
  spec.homepage      = "https://github.com/jennifergraceprince/cli-gem/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables << 'learn-about-cats'

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "colorize"
  spec.add_development_dependency "launchy"

  spec.add_dependency "nokogiri", ">= 1.8.5"
end
