# Mark Version

**A simple version tracking tool for the modern development workflow.**

Mark version was created to help track the version of ruby projects. It can be included as a gem with a command line interface to change the version of your project, provides classes for accessing the version information in project, integrates seamlessly with GIT and works in a complex development workflow.

## Installation

To install add the following to your Gemfile:

```
gem 'mark_version'
```

Or install manually:

```
gem install 'mark_version'
```

This will install the *version* binary. Once installed, the next thing you'll need to do is initialize your project. You can do this by running:

## Setup

```
version init
```

This will create a few config files, as well as the VERSION file. It is recommended that you add .mark_version/LOCAL_CONFIG to your .gitignore file and add commit the other files to source code control. Configuration options will be explored later in this README.

## Usage

Mark version is based on the semantic versioning standard. For more information on semantic versioning see http://semver.org.

### Basic Usage

Mark version comes with a built in binary for managing and viewing your application version. Here is the output of version -h:

```
Commands:
  version help [COMMAND]               # Describe available commands or one specific command
  version increment_release_candidate  # increments the current release candidate (n.n.n-RCX)
  version init                         # initialize the project to start tracking it's version
  version major                        # create a new major-level (X.n.n) release
  version major_release_candidate      # create a new major-level (X.n.n-RC1) release candidate
  version minor                        # create a new minor-level (n.X.n) release
  version minor_release_candidate      # create a new minor-level (n.X.n-RC1) release candidate
  version patch                        # create a new patch-level (n.n.X) release
  version release                      # releases the current release candidate (n.n.n)
  version show                         # print the current version level from the VERSION file
```

The three most basic commands for version management are:

```
version patch
```
Which increases the patch version of your project.

```
version minor
```
Which increases the minor version of your project, while resetting the patch version.

```
version major
```
Which increases the major version of your project, while resetting the minor and patch versions.

At any time, you can check the current version of your project by running:
```
version show
```

### Advanced Usage

If your development workflow involves the use of release candidates, mark version will be your friend. To create a new release candidate you can either run:

```
version minor_release_candidate
```

which will result in something like version "1.1.0-RC1"

OR

```
version major_release_candidate
```

which will result in something like version "2.0.0-RC1".

While your project is a release candidate you can run:

```
version increment_relese_candidate
```

which will result in something like this: "2.0.0-RC2".

You can release your release candidate by running:

```
version release
````

**NOTE: Mark Version automatically creates tags, but it is up to you to push these tags to your github repository.**

### Usage In Code

Mark Version is made to be used on the command line, and in your application code. One common use case is to print the version of your application to end users. In Rails you could do something like this:

```
<%= VersionFile.new.version %>
```

Or, for your development environment you could do something like this:

```
<% if Rails.env.development? %>
  <%= VersionFile.new.dev_version %>
<% end %>
```

The difference here is that dev_version will show you how many commits ahead of the last release the application is at, and, if you have release branches configured, it will point out when you are off of your release branch.

## Configuration

Mark Version installs two config files on initialization:

* .mark_version/CONFIG
* .mark_version/LOCAL_CONFIG

As mentioned before, it is recommended that you add .mark_version/LOCAL_CONFIG to your .gitignore list and commit .mark_version/CONFIG to source code control.

**Both config files use a JSON format.**

### Project Config

Project config is where you can specify your release branches. The default project config looks like this:

```
{
  "release_branches": ["master"]
}
```

You can add or remove release branches here depending on the needs of your project.

### Local Config

Local config allows for a options that each project team member can configure for their personal workflow. An example config file with all options included is shown below:

```
{
  "auto_push": true
}
```

With auto push on, tags created on new versions are pushed automatically.
