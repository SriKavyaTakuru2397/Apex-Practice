public class OpportunityTriggerHandler {
    public static void afterInsert(List<Opportunity> oppList) {
       
        Set<Id> accountIds = new Set<Id>();
        // List<Opportunity> allOpportunities = [
        //     SELECT Id, AccountId, Amount
        //     FROM Opportunity
        //     WHERE AccountId IN :accountIds
        // ];
        Map<Id, Decimal> accountToTotalAmountMap = new Map<Id, Decimal>();
        
        
        for (Opportunity opp : oppList) {
        
            if (opp.AccountId != null && opp.Amount != null) {
                accountIds.add(opp.AccountId);
                
                
                if (!accountToTotalAmountMap.containsKey(opp.AccountId)) {
                    accountToTotalAmountMap.put(opp.AccountId, 0);
                }
                
              
                accountToTotalAmountMap.put(opp.AccountId, accountToTotalAmountMap.get(opp.AccountId) + opp.Amount);
            }
        }

      
        List<Account> accountsToUpdate = [
            SELECT Id, All_Amount__c
            FROM Account
            WHERE Id IN :accountIds
        ];
        
     
        for (Account account : accountsToUpdate) {
           
            if (account.All_Amount__c == null) {
                account.All_Amount__c = 0;
            }
       
            account.All_Amount__c += accountToTotalAmountMap.get(account.Id);
        }
        

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
