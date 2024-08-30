public class ScheduleCreateTaskOnAccountWithNoOrder implements Schedulable{
    
    public void execute(SchedulableContext sc){
        Database.executeBatch(new createTaskOnAccountWithNoOrdersBatch());      
    }

    public static void scheduleBatch(){
        String cronExp = '0 0 2 ? * 2#1 *';
        String jobName = 'ScheduleCreateTaskOnAccountWithNoOrder';
        System.schedule(jobName, cronExp, new ScheduleCreateTaskOnAccountWithNoOrder());
    }
}