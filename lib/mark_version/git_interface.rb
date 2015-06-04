class GitInterface
  def self.branch
    `git rev-parse --abbrev-ref HEAD`
  end

  def self.ahead_of_master_by
    `git rev-list master..HEAD --count`
  end

  def self.ahead_of_version_by
    `git rev-list master..#{self.last_version_commit} --count`
  end

  def self.master?
    self.branch == 'master'
  end

  def self.closest_release_branch

  end

  def self.short_hash
    `git rev-parse --short HEAD`
  end

  def self.last_version_commit
    `git log --format="%h" LICENSE | head -n 1`
  end

  def self.commit
    `git add #{file_name}`
    `git commit -m "To version #{version}"`
  end

  def self.tag
    `git tag #{version} -a -m "Release version #{version}"`
  end
end
