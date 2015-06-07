require 'thor'

class MarkVersionCli < Thor
  default_task :show

  desc 'init', 'initialize the project to start tracking it\'s version'
  def init
    VersionFile.new.init
    commit_and_tag
  end

  desc 'patch', 'create a new patch-level (n.n.X) release'
  def patch
    VersionFile.new.patch
    commit_and_tag
  end

  desc 'minor', 'create a new minor-level (n.X.n) release'
  def minor
    VersionFile.new.minor
    commit_and_tag
  end

  desc 'major', 'create a new major-level (X.n.n) release'
  def major
    VersionFile.new.major
    commit_and_tag
  end

  desc 'minor_release_candidate', 'create a new minor-level (n.X.n-RC1) release candidate'
  def minor_release_candidate
    VersionFile.new.minor_release_candidate
    commit_and_tag
  end

  desc 'major_release_candidate', 'create a new major-level (X.n.n-RC1) release candidate'
  def major_release_candidate
    VersionFile.new.major_release_candidate
    commit_and_tag
  end

  desc 'increment_release_candidate', 'increments the current release candidate (n.n.n-RCX)'
  def increment_release_candidate
    VersionFile.new.increment_release_candidate
    commit_and_tag
  end

  desc 'release', 'releases the current release candidate (n.n.n)'
  def release
    VersionFile.new.release
    commit_and_tag
  end

  desc 'show', "print the current version level from the VERSION file"
  option :dev, type: :boolean
  def show
    if options[:dev]
      puts dev_version
    else
      puts version
    end
  end

  desc 'branch', 'get the current branch'
  def branch
    puts Git.branch
  end

  no_commands {
    def version
      VersionFile.new.version
    end

    def dev_version
      VersionFile.new.dev_version
    end

    def file_name
      VersionFile.new.file_name
    end

    def commit_and_tag
      Git.commit
      Git.tag
      Git.push if MarkVersionConfig.new.auto_push?
    end
  }
end
