trigger TaskTrigger on Task (before insert, before update, before delete, after insert, after update, after delete) {

    List<Account> accountsToUpdate = new List<Account>();

    Map<Id, Integer> countMap = new Map<Id, Integer>();

    String acctKeyPrefix = Account.getSObjectType().getDescribe().keyprefix;
    
    switch on Trigger.operationType {
        when AFTER_INSERT {
            for (Task tsk: Trigger.new){
            // is this an open task, with an account id in WhatId
                if (!tsk.Status.equals('Completed') && String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix){
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

        when AFTER_UPDATE {
            for (Task tsk: Trigger.new){
                // when status is updated on an account task, we need to act
                String tskStatus = tsk.Status;

                if (!tskStatus.equals(Trigger.oldMap.get(tsk.Id).Status) && String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix){
                    System.debug('an task with an account with an updated status happened.');
                    switch on tskStatus{
                        // tasks that now say "completed" should decrement task count from account.Number_Of_Open_Tasks__c
                        when 'Completed'{
                            if (!countMap.containsKey(tsk.WhatId)){
                                countMap.put(tsk.WhatId, -1);
                            } else {
                                countMap.put(tsk.WhatId, countMap.get(tsk.WhatId) - 1);
                            }
                        }
                        // tasks that now say anything but completed should increment the account.Number_Of_Open_Tasks__c
                        when 'Not Started', 'In Progress', 'Waiting on someone else', 'Deferred' {
                            if (!countMap.containsKey(tsk.WhatId)){
                                countMap.put(tsk.WhatId, 1);
                            } else {
                                countMap.put(tsk.WhatId, countMap.get(tsk.WhatId) + 1);
                            }
                        }
                        when else {
                            System.debug(LoggingLevel.ERROR,'There is an unhandled task status. Notify someone that a configuration change has occurred.');
                        }
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


        when AFTER_DELETE {
            for(Task tsk: Trigger.old){
                if (String.valueof(tsk.WhatId).substring(0,3) == acctKeyPrefix && !tsk.Status.equals('Completed')){
                    if (!countMap.containsKey(tsk.WhatId)){
                        countMap.put(tsk.WhatId, 1);
                    } else {
                        countMap.put(tsk.WhatId, countMap.get(tsk.WhatId) + 1);
                    }
                }
            }

            System.debug('countMap: ' + countMap);

            accountsToUpdate = [SELECT Id, Number_of_Open_Tasks__c FROM Account WHERE Id IN: countMap.keySet()];

            for(Account acct: accountsToUpdate){
                Integer currentTaskCount = Integer.valueOf(acct.Number_Of_Open_Tasks__c) ?? 0; 
                System.debug('currentTaskCount: ' + currentTaskCount);
                acct.Number_Of_Open_Tasks__c = currentTaskCount - countMap.get(acct.Id); 

            }

            update accountsToUpdate;
        }
            
        when else {
                
        }
    }

}