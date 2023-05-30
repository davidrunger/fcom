# frozen_string_literal: true

class Fcom::ConfigFileOptions
  prepend MemoWise

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

  memo_wise \
  def config_file_path
    "#{ENV.fetch('PWD')}/.fcom.yml"
  end

  def config_file_exists?
    File.exist?(config_file_path)
  end
end
