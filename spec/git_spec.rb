require 'mark_version'

describe Git do
  around(:each) do |e|
    Dir.mkdir('spec/fixtures/dummy_project') unless Dir.exists?('spec/fixtures/dummy_project') 
    Dir.chdir('spec/fixtures/dummy_project') do
      `git init`
      `touch hi`
      `git add .`
      `git commit -m "initial commit"`
    end

    Dir.chdir('spec/fixtures/dummy_project') do
      e.run
    end

    FileUtils.rm_rf('spec/fixtures/dummy_project')
  end

  it 'retrieves the current git repository branch' do
    expect(Git.branch).to eq('master')
  end

  it 'provides a short commit hash' do
    expect(Git.short_hash).to match(/[a-f0-9]{7}/)
  end
end
