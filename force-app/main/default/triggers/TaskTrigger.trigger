trigger TaskTrigger on Task (before insert, before update, before delete, after insert, after update, after delete) {

    List<Account> accountsToUpdate = new List<Account>();

    Map<Id, Integer> countMap = new Map<Id, Integer>();

    String keyPrefix = Account.getSObjectType().getDescribe().keyprefix;
    
    if (Trigger.isAfter && Trigger.isInsert){

        for (Task tsk: Trigger.new){
            // is this an open task, with an account id in WhatId
            if (!tsk.Status.equals('Completed') && String.valueof(tsk.WhatId).substring(0,3) == keyPrefix){
                if (!countMap.containsKey(tsk.WhatId)){
                    countMap.put(tsk.WhatId, 1);
                } else {
                    countMap.put(tsk.WhatId, countMap.get(tsk.WhatId) + 1);
                }
                
            }
            
        }

        accountsToUpdate = [SELECT Id, Number_of_Open_Tasks__c FROM Account WHERE Id IN: countMap.keySet()];

        for(Account acct: accountsToUpdate){
            Integer currentTaskCount = Integer.valueOf(acct.Number_Of_Open_Tasks__c) ?? 0; 
            acct.Number_Of_Open_Tasks__c = currentTaskCount + countMap.get(acct.Id); 
        }

        update accountsToUpdate; 

    }
}