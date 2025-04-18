# frozen_string_literal: true

require_relative 'lib/fcom/version'

Gem::Specification.new do |spec|
  spec.name          = 'fcom'
  spec.version       = Fcom::VERSION
  spec.authors       = ['David Runger']
  spec.email         = ['davidjrunger@gmail.com']

  spec.summary       = 'CLI tool for parsing git history'
  spec.homepage      = 'https://github.com/davidrunger/fcom'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['rubygems_mfa_required'] = 'true'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/davidrunger/fcom'
    spec.metadata['changelog_uri'] = 'https://github.com/davidrunger/fcom/blob/main/CHANGELOG.md'
  else
    raise('RubyGems 2.0 or newer is required to protect against public gem pushes.')
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
    end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('activesupport', '>= 6')
  spec.add_dependency('memo_wise', '>= 1.7')
  spec.add_dependency('rainbow', '>= 3.0')
  spec.add_dependency('slop', '~> 4.8')

  required_ruby_version = File.read('.ruby-version').rstrip.sub(/\A(\d+\.\d+)\.\d+\z/, '\1.0')
  spec.required_ruby_version = ">= #{required_ruby_version}"
end
