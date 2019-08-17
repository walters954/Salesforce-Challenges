@isTest
private class BatchContactTest {
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
    static testmethod void test() {        
        Test.startTest();
        BatchContact uca = new BatchContact();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
        
        // after the testing stops, assert records were updated properly
        System.assertEquals(2010, [select count() from Payment__c]);
    }

    static testmethod void testschedule() {        
        Test.startTest();
        SchedulerFirstOfMonth sh1 = new SchedulerFirstOfMonth();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
        
        
        // after the testing stops, assert records were updated properly
        System.assertEquals(2020, [select count() from Payment__c]);
    }
    
}