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
    project_configs['release_branches']
  end

  def add_release_branch(branch)
    configs = project_configs

    configs['release_branches'] = [] if configs['release_branches'].nil?

    configs['release_branches'] << branch

    write_project(configs)
  end

  def remove_release_branch(branch)
    configs = project_configs

    return false if configs['release_branches'].nil?

    configs['release_branches'] = configs['release_branches'] - [branch]

    write_project(configs)
  end

  def auto_push?
    local_configs['auto_push']
  end

  def set_auto_push(set)
    configs = local_configs

    configs['auto_push'] = set

    write_local(configs)
  end

  private

  def local_configs
    content = File.read(local_config_file)
    JSON.parse(content) rescue {}
  end

  def write_local(configs)
    File.write(local_config_file, configs.to_json)
  end

  def project_configs
    content = File.read(project_config_file)
    JSON.parse(content) rescue {}
  end

  def write_project(configs)
    File.write(project_config_file, configs.to_json)
  end
end
