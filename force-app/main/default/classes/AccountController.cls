public with sharing class AccountController {
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account LIMIT 30];
    }
}
