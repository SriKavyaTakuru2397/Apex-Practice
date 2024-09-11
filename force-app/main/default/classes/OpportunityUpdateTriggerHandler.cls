public class OpportunityUpdateTriggerHandler {
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        Set<Id> accIds = new Set<Id>();
        Map<Id, Decimal> accountToAmountMap = new Map<Id, Decimal>();
        
        
        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);
            
            if (opp.AccountId != null && (opp.Amount != oldOpp.Amount || opp.AccountId != oldOpp.AccountId)) {
                accIds.add(opp.AccountId);
                
                Decimal amountDifference = (opp.Amount != null ? opp.Amount : 0) - (oldOpp.Amount != null ? oldOpp.Amount : 0);
                
                if (!accountToAmountMap.containsKey(opp.AccountId)) {
                    accountToAmountMap.put(opp.AccountId, 0);
                }
                
                accountToAmountMap.put(opp.AccountId, accountToAmountMap.get(opp.AccountId) + amountDifference);
            }
        }
        

        List<Account> accountsToUpdate = [
            SELECT Id, All_Amount__c
            FROM Account
            WHERE Id IN :accIds
        ];
        
      
        for (Account account : accountsToUpdate) {
            
            if (account.All_Amount__c == null) {
                account.All_Amount__c = 0;
            }
            
            Decimal difference= accountToAmountMap.get(account.Id);
            if (difference != null) {
                account.All_Amount__c += difference;
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
