public with sharing class TaskTriggerHandler {

    List<Account> accountsToUpdate = new List<Account>();
    Map<Id, Integer> countMap = new Map<Id, Integer>();
    Set<Id> acctIdSet = new Set<Id>();

    String acctKeyPrefix = Account.getSObjectType().getDescribe().keyprefix;
    
    public void afterInsert(List<Task> newList) {
        for (Task tsk: newList){
            // is this an open task, with an account id in WhatId
            if (!tsk.IsClosed && String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix){
                acctIdSet.add(tsk.WhatId);
            }   
        }

        accountsToUpdate = getUpdatedAccounts(acctIdSet);

        update accountsToUpdate;
    }

    public void afterUpdate(Map<Id, Task> newMap, Map<Id,Task> oldMap) {
        for (Task tsk: newMap.values()){
            // when status is updated on an account task, we need to act
            Boolean closureChange = tsk.IsClosed != oldMap.get(tsk.Id).IsClosed;

            if (closureChange && String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix){
                acctIdSet.add(tsk.WhatId);
            }
        }
        
        accountsToUpdate = getUpdatedAccounts(acctIdSet);

        update accountsToUpdate;
    }

    public void afterDelete(Map<Id,Task> oldMap) {
        for(Task tsk: oldMap.values()){
            if (String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix){
                acctIdSet.add(tsk.WhatId);
            }
        }

        System.debug('acctIdSet');
        System.debug(acctIdSet);

        accountsToUpdate = getUpdatedAccounts(acctIdSet);

        update accountsToUpdate;
    }

    private List<Account> getUpdatedAccounts(Set<Id> accountIds) {
        List<Account> accountsToUpdateMap = new List<Account>();

        //retrieve all accounts in set
        accountsToUpdate = new [SELECT Id, Number_of_Open_Tasks__c FROM Account WHERE Id IN: accountIds];

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

        for(Account acc : accountsToUpdateMap) {
            acc.Number_of_Open_Tasks__c = acctIdToCountMap.get(acc.Id) ?? 0;
        }

        return accountsToUpdateMap;
    }
    
}