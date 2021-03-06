Feature: Message command
  As a user
  In order to know summary of current staged changes
  I want program to print me it

  Scenario: Run command on repository with staged changes
    Given one_commit_with_cached_diff git repository
    When I run meta_commit command `message`
    Then the output should contain "replace | in files SomeService.rb:1 SomeService.rb:1 (C17) | between commits 2c83758f0ff83ce42162d43bcebb71cf19849580 and staged"
     And the output should contain "replace | in files SomeService.rb:3 SomeService.rb:3 (C4) | between commits 2c83758f0ff83ce42162d43bcebb71cf19849580 and staged"
     And the output should contain "addition | in files SomeService.rb:-1 SomeService.rb:4 | between commits 2c83758f0ff83ce42162d43bcebb71cf19849580 and staged"

  Scenario: Run command on repository without staged changes
    Given three_commits_with_unstaged_diff git repository
    When I run meta_commit command `message`
    Then the output should not contain anything

  Scenario: Run command on repository without changes
    Given three_commits git repository
    When I run meta_commit command `message`
    Then the output should not contain anything
