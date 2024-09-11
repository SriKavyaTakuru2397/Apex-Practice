
@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void AccountAfterUpdateTest() {
        Account acc = new Account(Name = 'Test Account', Status__c = true);
        insert acc;
        
        
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName = 'sri', LastName = 'kavya', AccountId = acc.Id, Status__c = false));
        contacts.add(new Contact(FirstName = 'sree', LastName = 'kavya', AccountId = acc.Id, Status__c = false));
        insert contacts;
        Account account = [SELECT Id, Status__c FROM Account WHERE Name = 'Test Account'];
        
        
        account.Status__c = false;
        update account;
        List<Contact> updatedContacts = [SELECT Id, Status__c FROM Contact WHERE AccountId = :acc.Id];
        
        for (Contact c : updatedContacts) {
            System.assertEquals(false, c.Status__c);
        }
    }
}