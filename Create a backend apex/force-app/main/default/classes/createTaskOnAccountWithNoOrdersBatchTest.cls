@isTest
private class createTaskOnAccountWithNoOrdersBatchTest {
    
    // Test unitaire : exécution du batch sur un compte sans commande et sans Task de type Call associée
    @isTest 
    static void testcreateTaskOnAccountWithNoOrders() {
        Integer sizeTest = 1;
        String activeStatus = 'No';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
            
        Test.startTest();

        createTaskOnAccountWithNoOrdersBatch createTaskObj=new createTaskOnAccountWithNoOrdersBatch();
        Database.executeBatch(createTaskObj);
        
        Test.stopTest();
        
    List<Task> insertedTasks = [SELECT Id, WhatId, TaskSubtype, Subject, Status, Priority, IsReminderSet, ReminderDateTime FROM Task WHERE WhatId IN :accList];
    
    Boolean hasCallTask = false;
    for (Task tsk : insertedTasks) {
        if (tsk.TaskSubtype == 'Call') {
            hasCallTask = true;
            Assert.AreEqual('Call', tsk.Subject, 'Le sujet de la tâche doit être "Call".');
            Assert.AreEqual('Nouvelle', tsk.Status, 'Le statut de la tâche doit être "Nouvelle".');
            Assert.AreEqual('Normal', tsk.Priority, 'La priorité de la tâche doit être "Normal".');
            Assert.AreEqual(true, tsk.IsReminderSet, 'IsReminderSet doit être true.');
            Assert.AreEqual(System.now().addDays(5).date(), tsk.ReminderDateTime.date(), 'La date du rappel doit être 5 jours après la date actuelle.');
            break;
        }
    }
    Assert.isTrue(hasCallTask, 'Une tâche de type call devrait être associée au compte.');
}
    
    // Test unitaire : exécution du batch sur un compte avec commande et sans Task de type Call associée
    @isTest 
    static void testcreateTaskOnAccountWithOrders() {
        Integer sizeTest = 1;
        String activeStatus = 'Yes';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
            
        Test.startTest();

        createTaskOnAccountWithNoOrdersBatch createTaskObj=new createTaskOnAccountWithNoOrdersBatch();
        Database.executeBatch(createTaskObj);
        
        Test.stopTest();
        
    List<Task> insertedTasks = [SELECT Id, WhatId, TaskSubtype FROM Task WHERE WhatId IN :accList];
    
    Boolean hasCallTask = false;
    for (Task tsk : insertedTasks) {
        if (tsk.TaskSubtype == 'Call') {
            hasCallTask = true;
            break;
        }
    }
    Assert.isFalse(hasCallTask, 'Une tâche de type call ne doit pas être associée au compte.');
}
    
 // Test unitaire : exécution du batch sur un compte sans commande et avec 1 Task de type Call associée
    @isTest 
    static void testcreateTaskOnAccountWithNoOrdersWithcallTask() {
        Integer sizeTest = 1;
        String activeStatus = 'No';
        String taskType = 'Call';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);   
        List<Task> taskList = TestDataFactory.createTask(accList, sizeTest, taskType);
            
        Test.startTest();

        createTaskOnAccountWithNoOrdersBatch createTaskObj=new createTaskOnAccountWithNoOrdersBatch();
        Database.executeBatch(createTaskObj);
        
        Test.stopTest();
        
    List<Task> insertedTasks = [SELECT Id, WhatId, TaskSubtype FROM Task WHERE WhatId IN :accList];
  
    Map<Id, Integer> accountCallTaskCount = new Map<Id, Integer>();
    
    for (Task tsk : insertedTasks) {
        if (tsk.TaskSubtype == 'Call') {
            if (!accountCallTaskCount.containsKey(tsk.WhatId)) {
                accountCallTaskCount.put(tsk.WhatId, 0);
            }
            accountCallTaskCount.put(tsk.WhatId, accountCallTaskCount.get(tsk.WhatId) + 1);
        }
    }
    
    for (Id accountId : accountCallTaskCount.keySet()) {
        Integer callTaskCount = accountCallTaskCount.get(accountId);
        Assert.AreEqual(1, callTaskCount);
    }
}
    
    // Test unitaire : exécution du batch sur un compte avec commande et avec 1 Task de type Call associée
    @isTest 
    static void testcreateTaskOnAccountWithOrdersWithCallTask() {
        Integer sizeTest = 1;
        String activeStatus = 'Yes';
        String taskType = 'Call';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);   
        List<Task> taskList = TestDataFactory.createTask(accList, sizeTest, taskType);
            
        Test.startTest();

        createTaskOnAccountWithNoOrdersBatch createTaskObj=new createTaskOnAccountWithNoOrdersBatch();
        Database.executeBatch(createTaskObj);
        
        Test.stopTest();
        
 	List<Task> insertedTasks = [SELECT Id, WhatId, TaskSubtype FROM Task WHERE WhatId IN :accList];
  
    Map<Id, Integer> accountCallTaskCount = new Map<Id, Integer>();
    
    for (Task tsk : insertedTasks) {
        if (tsk.TaskSubtype == 'Call') {
            if (!accountCallTaskCount.containsKey(tsk.WhatId)) {
                accountCallTaskCount.put(tsk.WhatId, 0);
            }
            accountCallTaskCount.put(tsk.WhatId, accountCallTaskCount.get(tsk.WhatId) + 1);
        }
    }
    
    for (Id accountId : accountCallTaskCount.keySet()) {
        Integer callTaskCount = accountCallTaskCount.get(accountId);
        Assert.AreEqual(1, callTaskCount);
    }
}
    
    // Test unitaire : exécution du batch sur un compte avec 200 commandes sans commandes associées
    @isTest 
    static void testBulkcreateTaskOnAccountWithNoOrders() {
        Integer sizeTest = 200;
        String activeStatus = 'No';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
            
        Test.startTest();

        createTaskOnAccountWithNoOrdersBatch createTaskObj=new createTaskOnAccountWithNoOrdersBatch();
        Database.executeBatch(createTaskObj);
        
        Test.stopTest();
        
    List<Task> insertedTasks = [SELECT Id, WhatId, TaskSubtype, Subject, Status, Priority, IsReminderSet, ReminderDateTime FROM Task WHERE WhatId IN :accList];
    
    Boolean hasCallTask = false;
    for (Task tsk : insertedTasks) {
        if (tsk.TaskSubtype == 'Call') {
            hasCallTask = true;
            Assert.AreEqual('Call', tsk.Subject, 'Le sujet de la tâche doit être "Call".');
            Assert.AreEqual('Nouvelle', tsk.Status, 'Le statut de la tâche doit être "Nouvelle".');
            Assert.AreEqual('Normal', tsk.Priority, 'La priorité de la tâche doit être "Normal".');
            Assert.AreEqual(true, tsk.IsReminderSet, 'IsReminderSet doit être true.');
            Assert.AreEqual(System.now().addDays(5).date(), tsk.ReminderDateTime.date(), 'La date du rappel doit être 5 jours après la date actuelle.');
            break;
        }
    }
    Assert.isTrue(hasCallTask, 'Une tâche de type call devrait être associée aux comptes.');
}
    
}