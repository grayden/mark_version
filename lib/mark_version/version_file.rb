class VersionFile
  attr_reader :file_name

  def initialize(file_name = "#{MarkVersionConfig.new.base_folder_name}/VERSION")
    @file_name = "#{file_name}"
  end

  def init
    fail 'Project already initialized.' if file_exists?
    @version_file = open(file_name, 'w')
    @version_file.rewind
    @version_file.puts('0.0.0')
    @version_file.rewind
    @version_file.close
    version
  end

  def file_exists?
    File.file?(file_name)
  end

  def version
    fail "Version file '#{file_name}' does not exist." unless file_exists?

    @version_file = open(file_name, 'r+')
    version = @version_file.readline.chomp
    @version_file.close

    version
  end

  def dev_version
    return "#{version}.#{Git.branch}+#{Git.ahead_of_release_by}" unless Git.on_release_branch?
    return "#{version}+#{Git.current_ahead_by}" if Git.current_ahead_of_version?

    version
  end

  def short_version
    return version unless release_candidate?

    version.split('-')[0]
  end

  def patch
    fail 'Cannot patch a release candidate, it needs to be released first.' if release_candidate?
    version = version_as_array
    version[2] = (version[2].to_i + 1).to_s

    write(version.join('.'))
  end

  def minor
    fail 'Cannot minor increment a release candidate, it needs to be released first.' if release_candidate?
    version = version_as_array
    version[2] = '0'
    version[1] = (version[1].to_i + 1).to_s

    write(version.join('.'))
  end

  def major
    fail 'Cannot major increment a release candidate, it needs to be released first.' if release_candidate?
    version = version_as_array
    version[2] = '0'
    version[1] = '0'
    version[0] = (version[0].to_i + 1).to_s

    write(version.join('.'))
  end

  def minor_release_candidate
    fail 'Cannot make a releae candidate out of a release candidate. To increment to the next release candidate, invoke "increment_release_candidate".' if release_candidate?
    minor
    write("#{short_version}-RC1")
  end

  def major_release_candidate
    fail 'Cannot make a releae candidate out of a release candidate. To increment to the next release candidate, invoke "increment_release_candidate".' if release_candidate?
    major
    write("#{version}-RC1")
  end

  def increment_release_candidate
    fail 'Cannot increment the release candidate version on a non release candidate.' unless release_candidate?
    write("#{short_version}-RC#{next_release_candidate}")
  end

  def release
    fail 'Cannot release a non release candidate.' unless release_candidate?
    write(short_version)
  end

  def current_patch_version
    if version.include?('RC')
      version_as_array[2].split('-')[0]
    else
      version_as_array[2]
    end
  end

  def current_minor_version
    version_as_array[1]
  end

  def current_major_version
    version_as_array[0]
  end

  def release_candidate_iteration
    version.split('RC')[1].to_s
  end

  def release_candidate?
    version.include?('RC')
  end

  private

  def version_as_array
    version.split('.')
  end

  def next_release_candidate
    return 1 unless release_candidate?

    release_candidate_iteration.to_i + 1
  end

  def revision
    Git.short_hash
  end

  def write(version)
    fail "Version file '#{file_name}' does not exist." unless file_exists?
    @version_file = open(file_name, 'r+')
    @version_file.puts(version)
    @version_file.close
    version
  end
end
