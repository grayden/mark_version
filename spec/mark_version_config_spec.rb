require 'mark_version'

describe MarkVersionConfig do
  let(:folder_path) { 'spec/fixtures/.mark_version' }
  let(:config) { described_class.new('spec/fixtures/.mark_version') }

  before(:each) do
    File.write("#{folder_path}/LOCAL_CONFIG", '{ "auto_push": true }')
  end

  before(:each) do
    File.write("#{folder_path}/CONFIG", '')
  end

  it 'retrieves that the local environment should push tags' do
    expect(config.auto_push?).to eq(true)
  end

  it 'sets the local config to not push tags' do
    config.set_auto_push(false)
    expect(config.auto_push?).to eq(false)
  end

  it 'adds a release branch' do
    config.add_release_branch('master')
    expect(config.release_branches).to eq ['master']
  end

  it 'removes a release branch' do
    config.add_release_branch('master')
    config.add_release_branch('stable')

    config.remove_release_branch('master')

    expect(config.release_branches).to eq ['stable']
  end

  it 'returns false when there are no release branches to remove' do
    expect(config.remove_release_branch('master')).to eq(false)
  end
end
