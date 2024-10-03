trigger TaskTrigger on Task (before insert, before update, before delete, after insert, after update, after delete) {

    TaskTriggerHandler handler = new TaskTriggerHandler();
    
    switch on Trigger.operationType {
        when AFTER_INSERT {
            handler.afterInsert(Trigger.new);
        }

        when AFTER_UPDATE {
            handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
        }

        when AFTER_DELETE {
            handler.afterDelete(Trigger.oldMap);
        }
            
        when else {
                
        }
    }

}