require_relative './setting'

module ShareSetting
  def setting
    Setting.new({"file_path": "settings.yaml"})
  end
end
