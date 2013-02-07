Feature: hub ci-status

  Background:
    Given I am in "pencilbox" git repo
    Given the "origin" remote has url "git://github.com/michiels/pencilbox.git"
    And I am "michiels" on github.com with OAuth token "OTOKEN"

  Scenario: Fetch commit SHA
    Given there is a commit named "the_sha"
    Given the remote commit state of "michiels/pencilbox" "the_sha" is "success"
    When I run `hub ci-status the_sha`
    Then the output should contain exactly "success\n"
    And the exit status should be 0

  Scenario: Exit status 1 for 'error' and 'failure'
    Given the remote commit state of "michiels/pencilbox" "HEAD" is "error"
    When I run `hub ci-status`
    Then the exit status should be 1
    And the output should contain exactly "error\n"

  Scenario: Use HEAD when no sha given
    Given the remote commit state of "michiels/pencilbox" "HEAD" is "pending"
    When I run `hub ci-status`
    Then the exit status should be 2
    And the output should contain exactly "pending\n"

  Scenario: Exit status 3 for no statuses available
    Given there is a commit named "the_sha"
    Given the remote commit state of "michiels/pencilbox" "the_sha" is nil
    When I run `hub ci-status the_sha`
    Then the output should contain exactly "no status\n"
    And the exit status should be 3

  Scenario: Abort with message when invalid ref given
    When I run `hub ci-status this-is-an-invalid-ref`
    Then the exit status should be 1
    And the output should contain exactly "Aborted: no revision could be determined from 'this-is-an-invalid-ref'\n"

  Scenario: Non-GitHub repo
    Given the "origin" remote has url "mygh:Manganeez/repo.git"
    When I run `hub ci-status`
    Then the stderr should contain "Aborted: the origin remote doesn't point to a GitHub repository.\n"
    And the exit status should be 1