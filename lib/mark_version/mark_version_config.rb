require 'json'

class MarkVersionConfig
  attr_reader :base_folder_name

  def initialize(base_folder = '.mark_version')
    @base_folder_name = base_folder
  end

  def project_config_file
    "#{base_folder_name}/CONFIG"
  end

  def local_config_file
    "#{base_folder_name}/LOCAL_CONFIG"
  end

  def release_branches

  end

  def add_release_branch(branch)

  end

  def remove_release_branch(branch)

  end

  def auto_push?
    content = File.read(local_config_file)
    configs = JSON.parse(content)

    configs['push_tags']
  end

  def set_auto_push(set)
    content = File.read(local_config_file)
    configs = JSON.parse(content)

    configs['push_tags'] = set

    File.write(local_config_file, configs.to_json)
  end
end
