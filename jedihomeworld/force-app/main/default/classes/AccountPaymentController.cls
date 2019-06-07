public with sharing class AccountPaymentController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList(){
        return [SELECT Id, Name, Number_of_Non_void_Payments__c, AnnualRevenue FROM Account];
    }

    @AuraEnabled
    public static void voidPayments(String accountId){
        List<Payment__c> returnPaymentList = new List<Payment__c>();

        for (Payment__c pay : [SELECT id FROM Payment__c WHERE Account__c = :accountId]){
            pay.Void__c = true;
            returnPaymentList.add(pay);
        }
        update returnPaymentList;
    }

    //test method use for learning how apex refresh and pass parameters work
    // @AuraEnabled
    // public static void updateAccount(String accountId){
    //     Account acc = [SELECT id, AnnualRevenue FROM Account WHERE id = :accountId];
    //     if (acc.AnnualRevenue == null){
    //         acc.AnnualRevenue = 1;
    //     } else {
    //         acc.AnnualRevenue += 1;
    //     }
    //     update acc;
    // }
}
