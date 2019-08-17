@isTest
private with sharing class ContactHelperTest {
    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='USA'));
        }
        insert accounts;
        // find the account just inserted. add contact for each
        for (Account account : accounts) {
            contacts.add(new Contact(firstname='first', 
                lastname='last', accountId=account.Id));
        }
        insert contacts;
    }
    static testMethod void testSingle() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        Contact contact = [SELECT Id FROM Contact WHERE AccountId = :account.Id LIMIT 1];
        List<Payment__c> payments = new List<Payment__c>();
        payments.add(new Payment__c(Account__c = account.Id)); //null check
        payments.add(new Payment__c(Account__c = account.Id, Contact__c = contact.Id, Amount__c = 100, Payment_Date__c = System.today(), void__c = false)); //expect record
        payments.add(new Payment__c(Account__c = account.Id, Contact__c = contact.Id, Amount__c = 100, Payment_Date__c = System.today(), void__c = true)); //expect void
        payments.add(new Payment__c(Account__c = account.Id, Contact__c = contact.Id, Amount__c = 100, Payment_Date__c = System.today().addMonths(1), void__c = false)); //expect record next month
        payments.add(new Payment__c(Account__c = account.Id, Contact__c = contact.Id, Amount__c = 100, Payment_Date__c = System.today().addMonths(1), void__c = true)); //expect void next month
        insert payments;
        System.assertEquals(200.00, [SELECT Id, Total_Payment_Amount__c FROM Account WHERE Id = :account.Id].Total_Payment_Amount__c);
        System.assertEquals(100.00, [SELECT Id, Total_Payment_Amount_this_Month__c FROM Contact WHERE Id = :contact.Id].Total_Payment_Amount_this_Month__c);
    }

    static testMethod void testBatch(){
        List<Payment__c> payments = new List<Payment__c>();
        Double totalNonVoid = 0;
        for (Contact contact : [SELECT id, AccountId FROM Contact]) {
            for (Integer i=0; i< 200; i ++){
                Boolean voidBool = false;
                Double amount = 100;
                if (Math.mod(i, 2) == 0){
                    voidBool = true;
                    totalNonVoid += amount;
                }
                payments.add(new Payment__c(Account__c = contact.accountId, Amount__c = amount, Payment_Date__c = System.today(), void__c = voidBool, Contact__c = contact.Id));
            }
        }
        insert payments;

        Double testAmount = 0;
        for (Contact contact : [SELECT Id, Total_Payment_Amount_this_Month__c FROM Contact]){
            testAmount += contact.Total_Payment_Amount_this_Month__c;
        }

        System.assertEquals(totalNonVoid, testAmount);
    }
}