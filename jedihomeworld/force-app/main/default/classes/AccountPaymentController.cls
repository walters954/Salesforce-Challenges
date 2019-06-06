public with sharing class AccountPaymentController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList(){
        return [SELECT Id, Name, Number_of_Non_void_Payments__c FROM Account];
    }
}
