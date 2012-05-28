Feature: Get email
  In order to manage email a user should be able
  get email from their Gmail account
     
  Scenario: Get new mail from Gmail
    Given the user has a Gmail  account
    When they select get email from the menu
    Then they will see a list of new email
    

