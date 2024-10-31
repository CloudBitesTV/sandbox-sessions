public with sharing virtual class TriggerHandler {

    @TestVisible 
    protected List<SObject> newRecords;
    @TestVisible
    protected List<SObject> oldRecords;
    @TestVisible 
    protected Map<Id, SObject> newRecordMap;
    @TestVisible
    protected Map<Id, SObject> oldRecordMap;
    @TestVisible
    System.TriggerOperation context; 


    public TriggerHandler() {
        newRecords = Trigger.new;
        oldRecords = Trigger.old;
        newRecordMap = Trigger.newMap;
        oldRecordMap = Trigger.oldMap;
        context = Trigger.operationType;
    }

    public void run() {
        switch on context {
            when BEFORE_INSERT {
                beforeInsert();
            }

            when AFTER_INSERT {
                afterInsert();
            }

            when BEFORE_UPDATE {
                beforeUpdate();
            }
    
            when AFTER_UPDATE {
                afterUpdate();
            }
            
            when BEFORE_DELETE {
                beforeDelete();
            }
    
            when AFTER_DELETE {
                afterDelete();
            }
    
            when AFTER_UNDELETE {
                afterUndelete();
            }
        }
    }
    
    public virtual void beforeInsert() {
        
    }

    public virtual void afterInsert() {
        
    }

    public virtual void beforeUpdate() {

    }

    public virtual void afterUpdate() {
        
    }

    public virtual void beforeDelete() {

    }

    public virtual void afterDelete() {
        
    }

    public virtual void afterUndelete() {
        
    }
}