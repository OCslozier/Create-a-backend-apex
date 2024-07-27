public class ScheduleCreateTaskOnAccountWithNoOrder Implements Schedulable{
    
    public void execute(SchedulableContext sc){
        Database.executeBatch(new createTaskOnAccountWithNoOrdersBatch());      
    }
}