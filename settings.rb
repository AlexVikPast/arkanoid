require_relative './read_setting'

module Settings
  def settings
    ReadSetting.new({"file_path": "settings.yaml"})
  end
end
