@isTest
public with sharing class AccountController_Test {
    @TestSetup
    static void makeData(){
        insert new Account(Name = 'Engineering');
    }

    @IsTest
    static void testGetAccounts(){
        
        AccountController.getAccounts();
        
    }
}
