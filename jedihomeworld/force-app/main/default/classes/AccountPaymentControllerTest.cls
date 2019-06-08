@isTest
private with sharing class AccountPaymentControllerTest {

    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<Payment__c> payments = new List<Payment__c>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='USA'));
        }
        insert accounts;
        // find the account just inserted. add contact for each
        for (Account account : accounts) {
            contacts.add(new Contact(firstname='first', 
                lastname='last', accountId=account.id));
        }
        insert contacts;

        for (Contact contact : contacts) {
            for (Integer i=0; i< 201; i ++){
                payments.add(new Payment__c(Account__c = contact.accountId, Amount__c = 100, Payment_Date__c = System.today(), void__c = false, Contact__c = contact.Id));
            }
        }
        insert payments;
    }

    @isTest
    static void testGetAccounts()
    {
        List<Account> accounts = AccountPaymentController.getAccountList();
        System.assertEquals(10, accounts.size());
    }

    @isTest
    static void testVoidPayments()
    {
        List<Account> accounts = AccountPaymentController.getAccountList();
        Account account = null;
        if (accounts != null){
            account = accounts[0];
        }
        System.assertEquals(201, [SELECT count() FROM Payment__c WHERE Account__c = :account.Id and Void__c = false]); //void false
        AccountPaymentController.voidPayments(account.Id);
        System.assertEquals(201, [SELECT count() FROM Payment__c WHERE Account__c = :account.Id and Void__c = true]); // void true
    }
}

