trigger LeadTrigger on Lead (before insert) {
    LeadHandler.handle(Trigger.new);
}