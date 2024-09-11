public class OppContactScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        OpportunityContactAsync batch = new OpportunityContactAsync();
        Database.executeBatch(batch, 200);

    }
   
    public static void scheduleJob() {
       
        String cronExp = '0 0 8 * * ?';
        String jobName = 'Daily Opportunity Contact Batch Job';

        System.schedule(jobName, cronExp, new OppContactScheduler());
    }
} 