global class createTaskOnAccountWithNoOrdersBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext batchContext) {
        return Database.getQueryLocator([
            SELECT id, ownerId,
                (SELECT id FROM Orders), 
                (SELECT id, whatid, TaskSubtype FROM Tasks WHERE TaskSubtype = 'Task')
            FROM Account
        ]);
    }

    global void execute(Database.BatchableContext info, List<Account> scope) {
        List<Task> tasksToCreate = new List<Task>();

        for (Account acc : scope) {
            if (acc.Tasks.isEmpty() && acc.Orders.isEmpty()) {
                Task newTask = new Task(
                    WhatId = acc.Id,
                    ownerId = acc.OwnerId,
                    TaskSubtype = 'Task',
                    Subject = 'Call',
                    Status = 'Nouvelle',
                    Priority = 'Normal',
                    IsReminderSet = true,
                    ReminderDateTime = System.now().addDays(5)
                );
                tasksToCreate.add(newTask);
            }
        }

        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }

    global void finish(Database.BatchableContext info) {
 
    }
}