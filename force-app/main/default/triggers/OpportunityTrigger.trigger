trigger OpportunityTrigger on Opportunity (before insert) {
    if (Trigger.isAfter && Trigger.isInsert){
        OpportunityTriggerHandler.afterInsert(Trigger.new);
        
    }

}