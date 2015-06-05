require 'mark_version'

describe MarkVersionConfig do
  let(:folder_path) { 'spec/fixtures/.mark_version' }
  let(:config) { described_class.new('spec/fixtures/.mark_version') }

  before(:each) do
    File.write("#{folder_path}/LOCAL_CONFIG", '{ "push_tags": true }')
  end

  it 'retrieves that the local environment should push tags' do
    expect(config.auto_push?).to eq(true)
  end

  it 'sets the local config to not push tags' do
    config.set_auto_push(false)
    expect(config.auto_push?).to eq(false)
  end
end
