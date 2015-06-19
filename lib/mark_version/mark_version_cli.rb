require 'thor'

class MarkVersionCli < Thor
  default_task :show

  desc 'init', 'initialize the project to start tracking it\'s version'
  def init
    Project.init
  end

  desc 'patch', 'create a new patch-level (n.n.X) release'
  def patch
    Project.patch
  end

  desc 'minor', 'create a new minor-level (n.X.n) release'
  def minor
    Project.minor
  end

  desc 'major', 'create a new major-level (X.n.n) release'
  def major
    Project.major
  end

  desc 'minor_release_candidate', 'create a new minor-level (n.X.n-RC1) release candidate'
  def minor_release_candidate
    Project.minor_release_candidate
  end

  desc 'major_release_candidate', 'create a new major-level (X.n.n-RC1) release candidate'
  def major_release_candidate
    Project.major_release_candidate
  end

  desc 'increment_release_candidate', 'increments the current release candidate (n.n.n-RCX)'
  def increment_release_candidate
    Project.increment_release_candidate
  end

  desc 'release', 'releases the current release candidate (n.n.n)'
  def release
    Project.release
  end

  desc 'show', "print the current version level from the VERSION file"
  option :dev, type: :boolean
  def show
    if options[:dev]
      puts Project.dev_version
    else
      puts Project.version
    end
  end
end
