require 'thor'

class MarkVersionCli < Thor
  default_task :show

  def init
    VersionFile.new.init
    commit
    tag
  end

  desc 'patch', 'create a new patch-level (n.n.X) release'
  def patch
    VersionFile.new.patch
    commit
    tag
  end

  desc 'minor', 'create a new minor-level (n.X.n) release'
  def minor
    VersionFile.new.minor
    commit
    tag
  end

  desc 'major', 'create a new major-level (X.n.n) release'
  def major
    VersionFile.new.major
    commit
    tag
  end

  desc 'minor_release_candidate', 'create a new minor-level (n.X.n-RC1) release candidate'
  def minor_release_candidate
    VersionFile.new.minor_release_candidate
    commit
    tag
  end

  desc 'major_release_candidate', 'create a new major-level (X.n.n-RC1) release candidate'
  def major_release_candidate
    VersionFile.new.major_release_candidate
    commit
    tag
  end

  desc 'increment_release_candidate', 'increments the current release candidate (n.n.n-RCX)'
  def increment_release_candidate
    VersionFile.new.increment_release_candidate
    commit
    tag
  end

  desc 'release', 'releases the current release candidate (n.n.n)'
  def release
    VersionFile.new.release
    commit
    tag
  end

  desc 'show', "print the current version level from the VERSION file"
  def show
    puts version
  end

  no_commands {
    def version
      VersionFile.new.version
    end

    def file_name
      VersionFile.new.file_name
    end

    def commit
      system("git add #{file_name}")
      system("git commit -m 'To version #{version}'")
    end

    def tag
      system("git tag #{version} -a -m \"Release version #{version}\"")
    end
  }
end
