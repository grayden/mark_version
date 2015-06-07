require 'mark_version'

describe VersionFile do
  let(:file_path) { 'spec/fixtures/version_file.txt' }

  before(:each) do
    File.write(file_path, "0.9.12\n42324b")
    allow(Git).to receive(:current_ahead_of_version?).and_return(false)
    allow(Git).to receive(:on_release_branch?).and_return(true)
  end

  def version_file
    VersionFile.new(file_path)
  end

  it 'is able to get the version file name' do
    expect(version_file.file_name).to eq file_path
  end

  describe 'the current version' do
    context 'when at the current version' do
      it 'gets the current dev version from the file' do
        expect(version_file.dev_version).to eq('0.9.12')
      end

      it 'gets the current version from the file' do
        expect(version_file.version).to eq('0.9.12')
      end
    end

    context 'when ahead of the current version' do
      before(:each) do
        allow(Git).to receive(:current_ahead_of_version?).and_return(true)
        allow(Git).to receive(:current_ahead_by).and_return(4)
      end

      it 'the dev version shows the number of commits that have been added since the last version' do
        expect(version_file.dev_version).to eq('0.9.12+4')
      end

      it 'the version shows the basic semantic version number' do
        expect(version_file.version).to eq('0.9.12')
      end
    end

    context 'when on a feature branch' do
      before(:each) do
        allow(Git).to receive(:on_release_branch?).and_return(false)
        allow(Git).to receive(:ahead_of_release_by).and_return(7)
        allow(Git).to receive(:branch).and_return('feature_in_dev')
      end

      it 'shows the current feature branch and the number of commits that have been added to it' do
        expect(version_file.dev_version).to eq('0.9.12.feature_in_dev+7')
      end

      it 'the version shows the basic semantic version number' do
        expect(version_file.version).to eq('0.9.12')
      end
    end
  end

  context 'incrementing the patch version' do
    before(:each) do
      version_file.patch
    end

    it 'increments patch version' do
      expect(version_file.current_patch_version).to eq '13'
    end

    it 'keeps the minor version the same' do
      expect(version_file.current_minor_version).to eq '9'
    end

    it 'keeps the major version the same' do
      expect(version_file.current_major_version).to eq '0'
    end

    it 'does not be a release candidate' do
      expect(version_file.release_candidate?).not_to be
    end
  end

  context 'incrementing the minor version' do
    before(:each) do
      version_file.minor
    end

    it 'resets the patch version' do
      expect(version_file.current_patch_version).to eq '0'
    end

    it 'increments the minor version' do
      expect(version_file.current_minor_version).to eq '10'
    end

    it 'does not change the major version' do
      expect(version_file.current_major_version).to eq '0'
    end

    it 'does not be a release candidate' do
      expect(version_file).not_to be_release_candidate
    end
  end

  context 'incrementing the major version' do
    before(:each) do
      version_file.major
    end

    it 'resets the patch version' do
      expect(version_file.current_patch_version).to eq '0'
    end

    it 'resets the minor version' do
      expect(version_file.current_minor_version).to eq '0'
    end

    it 'increments major version' do
      expect(version_file.current_major_version).to eq '1'
    end

    it 'does not be a release candidate' do
      expect(version_file).not_to be_release_candidate
    end
  end

  context 'creating a minor version release candidate' do
    before(:each) do
      version_file.minor_release_candidate
    end

    it 'marks the version as a release candidate' do
      expect(version_file).to be_release_candidate
    end

    it 'resets the patch version' do
      expect(version_file.current_patch_version).to eq '0'
    end

    it 'increments the minor version' do
      expect(version_file.current_minor_version).to eq '10'
    end

    it 'does not change the major version' do
      expect(version_file.current_major_version).to eq '0'
    end

    it 'is at RC iteration 1' do
      expect(version_file.release_candidate_iteration).to eq '1'
    end

    it 'has RC and the RC version number at the end of the name' do
      expect(version_file.version).to eq '0.10.0-RC1'
    end
  end

  context 'creating a major version release candidate' do
    before(:each) do
      version_file.major_release_candidate
    end

    it 'marks the version as a release candidate' do
      expect(version_file).to be_release_candidate
    end

    it 'resets the patch version' do
      expect(version_file.current_patch_version).to eq '0'
    end

    it 'increments the minor version' do
      expect(version_file.current_minor_version).to eq '0'
    end

    it 'does not change the major version' do
      expect(version_file.current_major_version).to eq '1'
    end

    it 'is at RC iteration 1' do
      expect(version_file.release_candidate_iteration).to eq '1'
    end

    it 'has RC and the RC version number at the end of the name' do
      expect(version_file.version).to eq '1.0.0-RC1'
    end
  end

  context 'incrementing a minor version release candidate' do
    before(:each) do
      version_file.minor_release_candidate
      version_file.increment_release_candidate
    end

    it 'marks the version as a release candidate' do
      expect(version_file).to be_release_candidate
    end

    it 'resets the patch version' do
      expect(version_file.current_patch_version).to eq '0'
    end

    it 'increments the minor version' do
      expect(version_file.current_minor_version).to eq '10'
    end

    it 'does not change the major version' do
      expect(version_file.current_major_version).to eq '0'
    end

    it 'is at RC iteration 2' do
      expect(version_file.release_candidate_iteration).to eq '2'
    end

    it 'has RC and the RC version number at the end of the name' do
      expect(version_file.version).to eq '0.10.0-RC2'
    end
  end

  context 'incrementing a major version release candidate' do
    before(:each) do
      version_file.major_release_candidate
      version_file.increment_release_candidate
    end

    it 'marks the version as a release candidate' do
      expect(version_file).to be_release_candidate
    end

    it 'resets the patch version' do
      expect(version_file.current_patch_version).to eq '0'
    end

    it 'increments the minor version' do
      expect(version_file.current_minor_version).to eq '0'
    end

    it 'does not change the major version' do
      expect(version_file.current_major_version).to eq '1'
    end

    it 'is at RC iteration 2' do
      expect(version_file.release_candidate_iteration).to eq '2'
    end

    it 'has RC and the RC version number at the end of the name' do
      expect(version_file.version).to eq '1.0.0-RC2'
    end
  end

  context 'releasing a release candidate' do
    context 'minor release candidate' do
      before(:each) do
        version_file.minor_release_candidate
        version_file.release
      end

      it 'removes the release candidate' do
        expect(version_file).not_to be_release_candidate
      end

      it 'does not change the patch version' do
        expect(version_file.current_patch_version).to eq '0'
      end

      it 'does not change the minor version' do
        expect(version_file.current_minor_version).to eq '10'
      end

      it 'does not change the major version' do
        expect(version_file.current_major_version).to eq '0'
      end

      it 'goes back to looking like a normal release' do
        expect(version_file.version).to eq '0.10.0'
      end
    end

    context 'major release candidate' do
      before(:each) do
        version_file.major_release_candidate
        version_file.release
      end

      it 'removes the release candidate' do
        expect(version_file).not_to be_release_candidate
      end

      it 'does not change the patch version' do
        expect(version_file.current_patch_version).to eq '0'
      end

      it 'does not change the minor version' do
        expect(version_file.current_minor_version).to eq '0'
      end

      it 'does not change the major version' do
        expect(version_file.current_major_version).to eq '1'
      end

      it 'goes back to looking like a normal release' do
        expect(version_file.version).to eq '1.0.0'
      end
    end
  end

  context 'error conditions' do
    it 'does not be able to increment the release candidate unless the current version is some kind of release candidate' do
      expect { version_file.increment_release_candidate }.to raise_error
    end

    it 'does not be able to declare a minor release candidate unless the current version is not a release candidate' do
      version_file.minor_release_candidate

      expect { version_file.minor_release_candidate }.to raise_error
    end

    it 'does not be able to declare a minor release candidate unless the current version is not a release candidate' do
      version_file.minor_release_candidate

      expect { version_file.major_release_candidate }.to raise_error
    end

    it 'does not be able to increment the patch version on a release candidate' do
      version_file.minor_release_candidate

      expect { version_file.patch }.to raise_error
    end

    it 'does not be able to increment the minor version on a release candidate' do
      version_file.minor_release_candidate

      expect { version_file.minor }.to raise_error
    end

    it 'does not be able to increment the major version on a release candidate' do
      version_file.minor_release_candidate

      expect { version_file.major }.to raise_error
    end

    it 'cannot release a non release candidate' do
      expect { version_file.release }.to raise_error
    end
  end
end
