public class OpportunityContactAsync implements Database.Batchable<SObject>, System.Schedulable {

    private Integer daysRange;
    public OpportunityContactAsync(){

    }

    public OpportunityContactAsync(Integer daysRange){
        this.daysRange = daysRange;
        System.debug('daysRange '+daysRange);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, AccountId, Description, Name
            FROM Opportunity 
            WHERE AccountId = NULL
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        // Map<Id, Contact> contactMap = new Map<Id, Contact>();
        List<Account> accountsToInsert = new List<Account>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        Map<String, Account> newAccountsMap = new Map<String, Account>(); 
        
        Map<String, Contact> contactMap = new Map<String,Contact>();
        for(Contact contact : [SELECT Id, Name, AccountId FROM Contact LIMIT 40000]){

            contactmap.put(contact.Name, Contact);
        }
        //build above map with key as contact Name and value as related contact.
        // contactMap = new Map<Id, Contact>();
        /**
         * {"003000000aliad" : "Contact:{"Name" = "Test Contact", "AccountId" = "00100000023"}}
         */
        System.debug('Contact Map '+contactMap);    
        for (Opportunity opp : scope) {//10
            
            if(contactMap.containsKey(opp.Name)) {//10
              //s Contact relatedContact = contactMap.get(opp.Name);
                if (contactMap.get(opp.Name).AccountId != null) { //4 -> a,b,c,d
                    opp.AccountId = contactMap.get(opp.Name).AccountId;
                    oppToUpdate.add(opp);
                } else {//6 -> e,f,g,h,i.j
                    if (!String.isBlank(opp.Description)) {    
                        Account newAccount = new Account(Name = opp.Description);
                        accountsToInsert.add(newAccount);
                        newAccountsMap.put(opp.Description, newAccount);
                    }
                }
            }
        }
        System.debug(oppToUpdate);
        if (!accountsToInsert.isEmpty()) {
            insert accountsToInsert;
        }   
        for (Opportunity opp : scope) {//a,b,c,d,e,f,g,h,i,j
            Account insertedAccount = newAccountsMap.get(opp.Description);
            if (insertedAccount != null && insertedAccount.Id != null) {
                opp.AccountId = insertedAccount.Id;
                oppToUpdate.add(opp);

                Contact relatedContact = contactMap.get(opp.Name);
                if (relatedContact != null && relatedContact.AccountId == null) {
                    relatedContact.AccountId = insertedAccount.Id;
                    contactsToUpdate.add(relatedContact);
                }
            }
        }
        System.debug(oppToUpdate);
        if(!oppToUpdate.isEmpty()){
            update oppToUpdate;
        }
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
      
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Finished the task');
    }

    public void execute(System.SchedulableContext sContext){
        Database.executeBatch(new OpportunityContactAsync());
    }
    public static void scheduleJob() {
       
        String cronExp = '0 0 8 * * ?';
        String jobName = 'Daily Opportunity Contact Batch Job';

        System.schedule(jobName, cronExp, new OpportunityContactAsync());
    }
}
