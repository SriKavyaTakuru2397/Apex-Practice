trigger ContactTrigger on Contact (before insert,before update) {
    if (Trigger.isBefore){
        if(Trigger.isInsert){
        new TriggerHandler().beforeInsert(Trigger.new);
    }
    if (Trigger.isUpdate){
        new TriggerHandler().beforeUpdate(Trigger.new,Trigger.oldMap); 

}
    }
}