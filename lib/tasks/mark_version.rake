namespace :version do
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

  desc "create a new patch-level (n.n.X) release"

  task :patch => :environment do
    VersionFile.new.patch
    commit
    tag
  end

  desc "create a new minor-level (n.X.n) release"

  task :minor => :environment do
    VersionFile.new.minor
    commit
    tag
  end

  desc "create a new major-level (X.n.n) release"

  task :major => :environment do
    VersionFile.new.major
    commit
    tag
  end

  desc "create a new minor-level (n.X.n-RC1) release candidate"

  task :minor_release_candidate => :environment do
    VersionFile.new.minor_release_candidate
    commit
    tag
  end

  desc "create a new major-level (X.n.n-RC1) release candidate"

  task :major_release_candidate => :environment do
    VersionFile.new.major_release_candidate
    commit
    tag
  end

  desc "increments the current release candidate (n.n.n-RCX)"

  task :increment_release_candidate => :environment do
    VersionFile.new.increment_release_candidate
    commit
    tag
  end

  desc "releases the current release candidate (n.n.n)"

  task :release => :environment do
    VersionFile.new.release
    commit
    tag
  end

  desc "print the current version level from the VERSION file"

  task :show => :environment do
    puts version
  end
end
