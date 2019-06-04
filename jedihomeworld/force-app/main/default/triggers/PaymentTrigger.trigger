trigger PaymentTrigger on Payment__c (after update, after insert) {


    List<id> contactIdList = new List<id>();

    //Loops through payments 
    for (Payment__c pay : Trigger.new){
        if (pay.Contact__c != NULL){
            contactIdList.add(pay.Contact__c);
        }
    }

    //search for after delete to add to contact list
    contactHelper.updatePayments(contactIdList);
}