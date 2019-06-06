global class batchContact implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT Id FROM Contact'); // find way to automatically get id from query locator
    }
    global void execute(Database.BatchableContext bc, List<Contact> contacts){
        // process each batch of records
        Map<Id,Contact> contactMap = new Map<Id,Contact>(contacts); 
        contactHelper.updatePayments(contactMap.keySet());
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        system.debug('Process finished ' + bc);
        //email that goes to util class
    }    
}