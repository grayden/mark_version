class Project
  def self.init
    Dir.mkdir('.mark_version')
    VersionFile.new.init
    MarkVersionConfig.new.init
    commit_and_tag
  end

  def self.patch
    VersionFile.new.patch
    commit_and_tag
  end

  def self.minor
    VersionFile.new.minor
    commit_and_tag
  end

  def self.major
    VersionFile.new.major
    commit_and_tag
  end

  def self.minor_release_candidate
    VersionFile.new.minor_release_candidate
    commit_and_tag
  end

  def self.major_release_candidate
    VersionFile.new.major_release_candidate
    commit_and_tag
  end

  def self.increment_release_candidate
    VersionFile.new.increment_release_candidate
    commit_and_tag
  end

  def self.release
    VersionFile.new.release
    commit_and_tag
  end

  def self.version
    VersionFile.new.version
  end

  def self.dev_version
    VersionFile.new.dev_version
  end

  def self.commit_and_tag
    Git.commit(VersionFile.new.version)
    Git.tag(VersionFile.new.version)
    Git.push if MarkVersionConfig.new.auto_push?
  end
end
