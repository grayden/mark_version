class Git
  def self.branch
    `git rev-parse --abbrev-ref HEAD`.chomp
  end

  def self.ahead_of_version_by(branch)
    `git rev-list #{self.last_version_commit}..#{branch} --count`.chomp
  end

  def self.ahead_of_version?(branch)
    self.ahead_of_version_by(branch).to_i > 0
  end

  def self.current_ahead_of_version?
    ahead_of_version?('HEAD')
  end

  def self.current_ahead_by
    ahead_of_version_by('HEAD')
  end

  def self.ahead_of_release_by
    `git rev-list #{closest_release_branch}..HEAD --count`.chomp
  end

  def self.ahead_of_branch_by(branch)
    `git rev-list #{branch}..HEAD --count`.chomp
  end

  def self.closest_release_branch
    branch = nil
    distance = nil

    MarkVersionConfig.new.release_branches.each do |branch|
      if distance.nil? || ahead_of_branch_by(branch) < distance
        branch = branch
        distance = ahead_of_branch_by(branch)
      end
    end

    branch || 'master'
  end

  def self.on_release_branch?
    MarkVersionConfig.new.release_branches.include?(branch)
  end

  def self.short_hash
    `git rev-parse --short HEAD`.chomp
  end

  def self.last_version_commit
    `git log --format="%h" .mark_version/VERSION | head -n 1`.chomp
  end

  def self.commit_and_tag(version)
    commit(version)
    tag(version)
  end

  def self.commit(version)
    `git add .mark_version/VERSION`
    `git commit -m "To version #{version}"`
  end

  def self.tag(version)
    `git tag #{version} -a -m "Release version #{version}"`
  end

  def self.push
    `git push origin --tags`
  end
end
