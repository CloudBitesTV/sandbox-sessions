public with sharing class TaskTriggerHandler extends TriggerHandler {

    List<Account> accountsToUpdate = new List<Account>();
    Map<Id, Integer> countMap = new Map<Id, Integer>();
    Set<Id> acctIdSet = new Set<Id>();

    String acctKeyPrefix = Account.getSObjectType().getDescribe().keyprefix;
    
    public override void afterInsert() { 
        for (Task tsk: (List<Task>)newRecords) {
            // is this an open task, with an account id in WhatId
            if (!tsk.IsClosed && String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix){
                acctIdSet.add(tsk.WhatId);
            }   
        }

        accountsToUpdate = getUpdatedAccounts(acctIdSet);

        update accountsToUpdate;
    }

    public override void afterUpdate() {
        for (Task tsk: (List<Task>)newRecordMap.values()){
            // when status is updated on an account task, we need to act
            Task oldTask = (Task)oldRecordMap.get(tsk.Id);
            Boolean closureChange = tsk.IsClosed != oldTask.IsClosed;

            if (closureChange && String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix){
                acctIdSet.add(tsk.WhatId);
            }
        }
        
        accountsToUpdate = getUpdatedAccounts(acctIdSet);

        update accountsToUpdate;
    }

    public override void afterDelete() {
        for(Task tsk: (List<Task>)oldRecordMap.values()){
            if (String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix){
                acctIdSet.add(tsk.WhatId);
            }
        }

        accountsToUpdate = getUpdatedAccounts(acctIdSet);

        update accountsToUpdate;
    }

    private List<Account> getUpdatedAccounts(Set<Id> accountIds) {
        List<Account> accountsToUpdate = new List<Account>();

        //retrieve all accounts in set
        accountsToUpdate = [SELECT Id, Number_of_Open_Tasks__c FROM Account WHERE Id IN: accountIds];

        //run aggregate query for tasks grouping by account
        List<AggregateResult> taskAcctCounts = [SELECT Count(Id) TaskCount, WhatId AccountId 
                            FROM Task 
                            WHERE WhatId in: accountIds 
                                AND IsClosed = false AND IsDeleted = false
                            GROUP BY WhatId];

        Map<Id, Integer> acctIdToCountMap = new Map<Id, Integer>();
        for(AggregateResult result: taskAcctCounts) {
            Id acctId = (Id)result.get('AccountId');
            Integer taskCount = (Integer)result.get('TaskCount');
            acctIdToCountMap.put(acctId, taskCount);
        }

        for(Account acc : accountsToUpdate) {
            acc.Number_of_Open_Tasks__c = acctIdToCountMap.get(acc.Id) ?? 0;
        }

        return accountsToUpdate;
    }
    
}