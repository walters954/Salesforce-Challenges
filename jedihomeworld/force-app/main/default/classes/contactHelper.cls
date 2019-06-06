public with sharing class contactHelper {

    public static void updatePayments(Set<id>contactSetId){
        updatePayments(new List<id>(contactSetId));
    }

    public static void updatePayments(List<id> contactListId){

        //List of contact and payments
        Map<id,Contact> contactMap = new Map<id,Contact>([SELECT id, Name, (SELECT id, Name, Amount__c, Payment_Date__c FROM Payments__r WHERE Payment_Date__c = THIS_MONTH AND Void__c = False) FROM Contact WHERE id in:contactListId]);

        List<Contact> returnContacts = new List<Contact>();

        //loop over contacts
        for (Contact cont : contactMap.values()){
            system.debug(cont.Name);
            cont.Total_Payment_Amount_this_Month__c = 0;

            //loop over filtered payments
            for (Payment__c pay : cont.Payments__r){
                cont.Total_Payment_Amount_this_Month__c += pay.Amount__c;
            }

            //add to list of updated contacts
            returnContacts.add(cont);
        }

        update returnContacts;
    }
}