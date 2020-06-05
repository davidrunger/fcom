# frozen_string_literal: true

class Fcom::ConfigFileOptions
  def initialize
    config_file_path = "#{ENV['PWD']}/.fcom.yml"
    @options =
      if File.exist?(config_file_path)
        YAML.load_file(config_file_path)
      else
        {}
      end
  end

  def repo
    @options['repo']
  end
end
