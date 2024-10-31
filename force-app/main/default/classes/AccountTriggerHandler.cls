public with sharing class AccountTriggerHandler extends TriggerHandler {
    
    public override void beforeInsert() {
        for(Account acc : (List<Account>)newRecords) {
            acc.Description = acc.Name; 
        }
    }

}