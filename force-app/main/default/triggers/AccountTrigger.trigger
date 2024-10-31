trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
    handler.run(); 
}