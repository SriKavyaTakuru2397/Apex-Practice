public class LeadContactFieldsMatch implements Database.Batchable<sObject> {

    public Map<Id, List<Contact>> leadToContactsMap = new Map<Id, List<Contact>>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, Email, Phone FROM Lead]);
    }

    public void execute(Database.BatchableContext bc, List<Lead> leadList) {
        
       
        Map<String, List<Contact>> nameToContactsMap = new Map<String, List<Contact>>();
        
        Set<String> matchedFields = new Set<String>();
       

        for (Lead lead : leadList) {
       
        if (lead.Email != null && lead.Name!=null && lead.Phone!=null) {
                    matchedFields.add(lead.Email);
                    matchedFields.add(lead.Name);
                    matchedFields.add(lead.Phone);

                }
            }

        List<Contact> contacts = [
            SELECT Id, Name, Email, Phone
            FROM Contact
            WHERE Id in :matchedFields 
        ];

       
       
      

        for (Contact contact : contacts) {
            
            if (!nameToContactsMap.containsKey(contact.Name)&&
            (!nameToContactsMap.containsKey(contact.Phone))
            &&(!nameToContactsMap.containsKey(contact.Email))) {
                nameToContactsMap.put(contact.Name, new List<Contact>());
                nameToContactsMap.put(contact.Email, new List<Contact>());
                nameToContactsMap.put(contact.Phone, new List<Contact>());
            }
            nameToContactsMap.get(contact.Name).add(contact);
            nameToContactsMap.get(contact.Email).add(contact);
            nameToContactsMap.get(contact.Phone).add(contact);
            
        }

        
      for (Lead lead : leadList) {
            List<Contact> matchedContacts = new List<Contact>();
            Integer matchCount = 0;

           
            if (nameToContactsMap.containsKey(lead.Email)&&nameToContactsMap.containsKey(lead.name)
            &&nameToContactsMap.containsKey(lead.Phone)) {
                matchCount++;
                matchedContacts.addAll(nameToContactsMap.get(lead.Email));
                matchedContacts.addAll(nameToContactsMap.get(lead.Phone));
                matchedContacts.addAll(nameToContactsMap.get(lead.Name));
            }

            
           if (matchCount >= 2) {
                leadToContactsMap.put(lead.Id, matchedContacts);
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Lead to Contacts Map: ' + leadToContactsMap);
    }

    public Map<Id, List<Contact>> getLeadToContactsMap() {
        return leadToContactsMap;
    }
}
