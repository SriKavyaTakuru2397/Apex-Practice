trigger OpportunityUpdateTrigger on opportunity (after Update) {
    if (Trigger.isAfter && Trigger.isUpdate){

        OpportunityUpdateTriggerHandler.afterUpdate(Trigger.new,Trigger.oldMap);
        
        
    }
    }

