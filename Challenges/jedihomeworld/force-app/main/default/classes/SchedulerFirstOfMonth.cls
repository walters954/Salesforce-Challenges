global with sharing class SchedulerFirstOfMonth implements Schedulable {
    global void execute(SchedulableContext ctx) {
        batchContact b = new batchContact();
        database.executebatch(b);
    }
}
