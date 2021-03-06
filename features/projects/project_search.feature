@no-txn
Feature: Projects search
  In order to find projects
  As a user with an account
  I want to be able to search and filter projects

  Background: logged in
  Given the project statuses are setup
    And the following projects
    | name                | status    | sectors           | location     | partners       | total_cost  |
    | Small Project       | active    | Education,Health  | Turbekistan  | Tag Solutions  | 2500        |
    | Medium Project 1    | active    | Education         | Turbekistan  | Tag Solutions  | 6000        |
    | Medium Project 2    | active    | Health            | Turbekistan  | Tag Solutions  | 6000        |
    | Large Project       | active    | Health            | Cape Breton  | ACME Hardware  | 12000       |
    | Old Project         | completed | Health            | Greece       | Other Thingnn  | 2500       |
    And the project indexes are processed

  Scenario: Project filters
    Given I am on the projects page
    Then I should see "☐ Active (4)"
    And I should see "☐ Completed (1)"
    And I should see "☐ Health (4)"
    And I should see "☐ Education (2)"
    And I should see "☐ Turbekistan (3)"
    And I should see "☐ Cape Breton (1)"
    And I should see "☐ Tag Solutions (3)"
    And I should see "☐ ACME Hardware (1)"
    And I should see "☐ $0 - $5,000 (2)" within ".project-filter"
    And I should see "☐ $5,001 - $10,000 (2)" within ".project-filter"
    And I should see "☐ $10,001 - $15,000 (1)" within ".project-filter"

  Scenario: Project sort order (active before completed)
    Given I am on the projects page
    Then the project list should have "Small Project" before "Old Project"
    And the project list should have "Medium Project 1" before "Old Project"
    And the project list should have "Medium Project 2" before "Old Project"
    And the project list should have "Large Project" before "Old Project"

  Scenario: Status results count
    Given I am on the projects page
    And I follow "☐ Active (4)"
    Then I should see 4 projects listed
    And I should see "☒ Active"
    And I should see "Small Project"
    And I should not see "Old Project"

  Scenario: Sector results count, multiple facets
    Given I am on the projects page
    When I follow "☐ Health (4)"
    And I should see "☒ Health"
    And I should see "☒ Active"
    Then I should see 3 projects listed
    When I follow "Active" within ".term"
    Then I should see 4 projects listed
    And the project list should have "Small Project" before "Old Project"
    And the project list should have "Medium Project 2" before "Old Project"
    And the project list should have "Large Project" before "Old Project"
    And I should see "Medium Project 2"
    And I should not see "Medium Project 1"
    And I should see "☒ Health"
    And I should see "☐ Education (2)"
    And I should see "☐ Turbekistan (2)"
    And I should see "☐ Cape Breton (1)"
    And I should see "☐ $0 - $5,000 (2)"
    And I should see "☐ $5,001 - $10,000 (1)"
    And I should see "☐ $10,001 - $15,000 (1)"
    When I follow "☐ Education (2)"
    Then I should see 5 projects listed
    And I should see "☒ Health"
    And I should see "☒ Education"
    And I should see "☐ Turbekistan (3)"
    And I should see "☐ Cape Breton (1)"
    And I should see "☐ $0 - $5,000 (2)"
    And I should see "☐ $5,001 - $10,000 (2)"
    And I should see "☐ $10,001 - $15,000 (1)"
    When I follow "☐ Turbekistan (3)"
    Then I should see 3 projects listed
    And I should see "☒ Health"
    And I should see "☒ Education"
    And I should see "☒ Turbekistan"
    And I should see "☐ Cape Breton (1)"
    And I should see "☐ $0 - $5,000 (1)"
    And I should see "☐ $5,001 - $10,000 (2)"
    And I should see "☐ $10,001 - $15,000 (0)"

  Scenario: Location results count
    Given I am on the projects page
    And I follow "☐ Turbekistan (3)"
    Then I should see 3 projects listed
    And I should see "Small Project"
    And I should not see "Large Project"
    And I should see "Turbekistan"
    And I should see "☐ Cape Breton (1)"
    And I should see "☐ Health (2)"
    And I should see "☐ Education (2)"

  Scenario: Partner results count
    Given I am on the projects page
    And I follow "☐ Tag Solutions (3)"
    Then I should see 3 projects listed
    And I should see "Small Project"
    And I should see "Tag Solutions"
    And I should see "☐ ACME Hardware (1)"
    And I should see "☐ Health (2)"
    And I should see "☐ Education (2)"

  Scenario: Cost results count
    Given I am on the projects page
    And I follow "☐ $5,001 - $10,000 (2)"
    Then I should see 2 projects listed
    And I should see "Medium Project 1"
    And I should not see "Large Project"
    And I should see "☒ $5,001 - $10,000 (2)"
    And I should see "☐ Health (1)"
    And I should see "☐ Education (1)"

  Scenario: Cost results sort
    Given I am on the projects page
    And I follow "☐ $0 - $5,000 (2)"
    Then I should see 2 projects listed
    And the project list should have "Small Project" before "Old Project"

  Scenario: Keyword search on sector name
    Given I am on the projects page
    And I fill in "search[search_text]" with "Tag Solutions"
    And I press "Search"
    Then I should see "Small Project"
    Then I should see "Medium Project 1"
    Then I should see "Medium Project 2"
    Then I should not see "Large Project"

  Scenario: Keyword search on partner name
    Given I am on the projects page
    And I fill in "search[search_text]" with "Education"
    And I press "Search"
    Then I should see "Small Project"
    Then I should see "Medium Project 1"
    Then I should not see "Medium Project 2"
    Then I should not see "Large Project"

  Scenario: Backwards compatability for total_cost comma separation
    Given I search with a deprecated total_cost param of "5001%2C10000"
    Then I should see 2 projects listed
    And I should see "$5,001 - $10,000" within ".term"