@isTest
private with sharing class AccountTriggerHandler_Test {
 
    @isTest
    private static void testInsert() {
        Account acc = new Account();
        acc.Name = 'Dummy';
        
        AccountTriggerHandler handler = new AccountTriggerHandler();
        handler.newRecords = new List<Account>{acc};
 
        Test.startTest();
        handler.beforeInsert();
        Test.stopTest();

        acc = (Account)handler.newRecords[0];

        System.Assert.areEqual(acc.Name, acc.Description);
    }
}