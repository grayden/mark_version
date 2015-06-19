require 'mark_version'

describe Project do
  around(:each) do |e|
    Dir.mkdir('spec/fixtures/dummy_project') unless Dir.exists?('spec/fixtures/dummy_project') 
    Dir.chdir('spec/fixtures/dummy_project') do
      `git init`
      `touch hi`
      `git add hi`
      `git commit -m "initial commit"`
    end

    Dir.chdir('spec/fixtures/dummy_project') do
      e.run
    end

    FileUtils.rm_rf('spec/fixtures/dummy_project')
  end

  it 'initializes a project with version 0.0.0' do
    described_class.init

    expect(described_class.version).to eq('0.0.0')
  end

  context 'initialized project' do
    before(:each) do
      described_class.init
      MarkVersionConfig.new.add_release_branch('master')
    end

    context 'on a release branch' do
      it 'shows a project version' do
        expect(described_class.version).to be
      end

      context 'when creating a patch' do
        before(:each) do
          described_class.patch
        end

        it 'increments the project patch number' do
          expect(described_class.version).to eq('0.0.1')
        end
      end

      context 'when adding a minor version' do
        before(:each) do
          described_class.minor
        end

        it 'increments the project minor number' do
          expect(described_class.version).to eq('0.1.0')
        end
      end

      context 'when adding a major version' do
        before(:each) do
          described_class.major
        end

        it 'increments the project major number' do
          expect(described_class.version).to eq('1.0.0')
        end
      end

      context 'creating a minor release candidate' do
        before(:each) do
          described_class.minor_release_candidate
        end

        it 'increments the project minor number and marks it as a release candidate' do
          expect(described_class.version).to eq('0.1.0-RC1')
        end

        context 'then incrementing a release candidate' do
          before(:each) do
            described_class.increment_release_candidate
          end

          it 'increments the release candidate number' do
            expect(described_class.version).to eq('0.1.0-RC2')
          end
        end

        context 'then releasing the project' do
          before(:each) do
            described_class.release
          end

          it 'changes the version to released' do
            expect(described_class.version).to eq('0.1.0')
          end
        end
      end

      context 'creating a major release candidate' do
        before(:each) do
          described_class.major_release_candidate
        end

        it 'increments the project major number and marks it as a release candidate' do
          expect(described_class.version).to eq('1.0.0-RC1')
        end
      end

      context 'then adding a commit' do
        before(:each) do
          `touch hello`
          `git add .`
          `git commit -m "second commit"`
        end

        it 'keeps the same default version' do
          expect(described_class.version).to eq('0.0.0')
        end

        it 'shows details in the dev version' do
          expect(described_class.dev_version).to eq('0.0.0+1')
        end
      end
    end

    context 'off of a release branch' do
      before(:each) do
        `git checkout -b feature1 2> /dev/null`
      end

      it 'provides a dev version that shows the current branch plus 0' do
        expect(described_class.dev_version).to eq('0.0.0.feature1+0')
      end

      context 'then adding a commit' do
        before(:each) do
          `touch hello`
          `git add .`
          `git commit -m "second commit"`
        end

        it 'provides a dev version that shows progress down the release branch' do
          expect(described_class.dev_version).to eq('0.0.0.feature1+1')
        end
      end
    end
  end
end
