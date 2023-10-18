require 'yaml'

class ReadSetting
  @@file_path = "settings.yaml"

  attr_reader :file_path

  def initialize(param = {})
    @file_path = param[:file_path] || @@file_path
  end

  def value(key)
    get_settings[key]
  end

  private
  def get_settings
    if file_present?
      YAML.load_file(@file_path)
    else
      puts "File ---> settings no found"
      exit
    end
  end

  def file_present?
    File.exist?(@file_path) 
  end
end

module Setting
  def setting
    ReadSetting.new({"file_path": "settings.yaml"})
  end
end