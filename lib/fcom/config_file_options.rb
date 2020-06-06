# frozen_string_literal: true

class Fcom::ConfigFileOptions
  extend Memoist

  def initialize
    @options =
      if config_file_exists?
        YAML.load_file(config_file_path)
      else
        {}
      end
  end

  def repo
    @options['repo']
  end

  private

  memoize \
  def config_file_path
    "#{ENV['PWD']}/.fcom.yml"
  end

  def config_file_exists?
    File.exist?(config_file_path)
  end
end
