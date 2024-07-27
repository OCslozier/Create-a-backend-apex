global class createTaskOnAccountWithNoOrdersBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext batchContext) {
        return Database.getQueryLocator([
            SELECT Id, Active__c, (SELECT Id, WhatId, TaskSubtype FROM Tasks WHERE TaskSubtype = 'Call')
            FROM Account
            WHERE Active__c = 'no'
        ]);
    }
        
    global void execute(Database.BatchableContext info, List<Account> scope) {
        List<Task> tasksToCreate = new List<Task>();

        for (Account acc : scope) {
            if (acc.Tasks.isEmpty()) {
                Task newTask = new Task(
                    WhatId = acc.Id,
                    TaskSubtype = 'Call',
                    Subject = 'Call',
                    Status = 'Nouvelle',
                    Priority = 'Normal',
                    IsReminderSet = true,
					ReminderDateTime = System.now().addDays(5) // Ajouter 5 jours à la date actuelle
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