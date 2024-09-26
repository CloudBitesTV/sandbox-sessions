@isTest
private with sharing class TaskTrigger_Test {
    
    @isTest
    private static void testInsertSingleTask() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Task tsk = new Task();
        tsk.WhatId = acc.Id;
        tsk.Subject = 'Test task';
        tsk.Status = 'Not Started';
        
        Test.startTest();

        insert tsk;

        Test.stopTest();

        acc = [SELECT Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(1, acc.Number_of_Open_Tasks__c, 'Incorrect number of open tasks on account');

    }

    @isTest
    private static void testInsertMultipleTasksAllOpen() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Task tsk1 = new Task();
        tsk1.WhatId = acc.Id;
        tsk1.Subject = 'Test task 1';
        tsk1.Status = 'Not Started';

        Task tsk2 = new Task();
        tsk2.WhatId = acc.Id;
        tsk2.Subject = 'Test task 2';
        tsk2.Status = 'Not Started';
        
        Test.startTest();

        insert new List<Task>{tsk1, tsk2};

        Test.stopTest();

        acc = [SELECT Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(2, acc.Number_of_Open_Tasks__c, 'Incorrect number of open tasks on account');

    }

    @isTest
    private static void testInsertMultipleTasksMixedOpenClosed() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Task tsk1 = new Task();
        tsk1.WhatId = acc.Id;
        tsk1.Subject = 'Test task 1';
        tsk1.Status = 'Not Started';

        Task tsk2 = new Task();
        tsk2.WhatId = acc.Id;
        tsk2.Subject = 'Test task 2';
        tsk2.Status = 'Not Started';

        Task tsk3 = new Task();
        tsk3.WhatId = acc.Id;
        tsk3.Subject = 'Test task 3';
        tsk3.Status = 'Completed';
        
        Test.startTest();

        insert new List<Task>{tsk1, tsk2, tsk3};

        Test.stopTest();

        acc = [SELECT Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(2, acc.Number_of_Open_Tasks__c, 'Incorrect number of open tasks on account');

    }


    @isTest
    private static void testInsertMultipleAccountsAllOpen() {
        Account acc = new Account();
        acc.Name = 'Test Account';

        Account acc2 = new Account();
        acc2.Name = 'Test Account 2';
        
        insert new List<Account>{acc, acc2};

        Task tsk1 = new Task();
        tsk1.WhatId = acc.Id;
        tsk1.Subject = 'Test task 1';
        tsk1.Status = 'Not Started';

        Task tsk2 = new Task();
        tsk2.WhatId = acc2.Id;
        tsk2.Subject = 'Test task 2';
        tsk2.Status = 'Not Started';
        
        Test.startTest();

        insert new List<Task>{tsk1, tsk2};

        Test.stopTest();

        acc = [SELECT Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(1, acc.Number_of_Open_Tasks__c, 'Incorrect number of open tasks on account');

        acc2 = [SELECT Number_of_Open_Tasks__c FROM Account WHERE Id = :acc2.Id];
        System.Assert.areEqual(1, acc2.Number_of_Open_Tasks__c, 'Incorrect number of open tasks on account');

    }


    @isTest
    private static void testInsertSingleTaskOnCampaign() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Campaign cmp = new Campaign();
        cmp.Name = 'Test Campaign';
        insert cmp;

        Task tsk = new Task();
        tsk.WhatId = cmp.Id;
        tsk.Subject = 'Test task';
        tsk.Status = 'Not Started';
        
        Test.startTest();

        insert tsk;

        Test.stopTest();

        acc = [SELECT Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(null, acc.Number_of_Open_Tasks__c, 'Incorrect number of open tasks on account');

    }


    @isTest
    private static void testInsertMultipleAccountsHalfOpenBulk() {
        Account acc = new Account();
        acc.Name = 'Test Account';

        Account acc2 = new Account();
        acc2.Name = 'Test Account 2';
        
        insert new List<Account>{acc, acc2};

        List<Task> tasks = new List<Task>();

        for(Integer i = 0; i < 201; i++) {
            Boolean mod2 = Math.mod(i, 2) == 0;            
            Task tsk = new Task();
            tsk.WhatId = mod2 ? acc.Id : acc2.Id;
            tsk.Subject = 'Test task ' + i;
            tsk.Status = mod2 ? 'Not Started' : 'Completed';
            tasks.add(tsk);
        }
        
        Test.startTest();

        insert tasks;

        Test.stopTest();

        acc = [SELECT Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(101, acc.Number_of_Open_Tasks__c, 'Incorrect number of open tasks on account');

        acc2 = [SELECT Number_of_Open_Tasks__c FROM Account WHERE Id = :acc2.Id];
        System.Assert.areEqual(null, acc2.Number_of_Open_Tasks__c, 'Incorrect number of open tasks on account');

    }

    @isTest
    private static void testUpdateSingleTaskFromOtherToCompleted() {
        // this should mean a start state of a task related to an account with the account having the
        // Number_of_Open_Tasks__c field set to 1. After the udpate it should be 0. 
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Task tsk = new Task();
        tsk.WhatId = acc.Id;
        tsk.Subject = 'Test task';
        tsk.Status = 'Not Started';
            
        insert tsk;
            
        acc = [SELECT Id, Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(1, acc.Number_of_Open_Tasks__c, 'Start state: Incorrect number of open tasks on account');
        
        Task taskToUpdate = new Task();
        taskToUpdate.Id = tsk.Id;
        taskToUpdate.Status = 'Completed';

        Test.startTest();

        update taskToUpdate;

        Test.stopTest();

        acc = [SELECT Id, Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(0, acc.Number_of_Open_Tasks__c, 'Post test: Incorrect number of open tasks on account');
    }

    @isTest
    private static void testUpdateSingleTaskFromCompletedToOther() {
        // this should mean a start state of a task related to an account with the account having the
        // Number_of_Open_Tasks__c field set to null. After the udpate it should be 1. 
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Task tsk = new Task();
        tsk.WhatId = acc.Id;
        tsk.Subject = 'Test task';
        tsk.Status = 'Completed';
            
        insert tsk;
            
        acc = [SELECT Id, Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(null, acc.Number_of_Open_Tasks__c, 'Start state: Incorrect number of open tasks on account');
        
        Task taskToUpdate = new Task();
        taskToUpdate.Id = tsk.Id;
        taskToUpdate.Status = 'In Progress';

        Test.startTest();

        update taskToUpdate;

        Test.stopTest();

        acc = [SELECT Id, Number_of_Open_Tasks__c FROM Account WHERE Id = :acc.Id];
        System.Assert.areEqual(1, acc.Number_of_Open_Tasks__c, 'Post test: Incorrect number of open tasks on account');
    }
    // Note on this last test: the start state post insert of a task that was immediately set to "completed" is not 0
    // it is null. In a real project, I would think there would be a short discussion of how to actually design
    // such a trigger. Is a "null" state for the Number_of_Open_Tasks__c field the right value when there is at least
    // one task associated (no matter the status)? Or should there always be a zero? And how to handle that (such as
    // a default value of zero for the field). A consistent numeric value might help with reporting in some instances.

    // This also dovetails in to a TDD discussion. If the test was written for zero, then the original design of the
    // insert trigger would break the test. 
}