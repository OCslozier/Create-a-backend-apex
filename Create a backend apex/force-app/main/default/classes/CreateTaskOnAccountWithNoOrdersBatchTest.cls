@isTest
private class CreateTaskOnAccountWithNoOrdersBatchTest {
    
    // Test unitaire : exécution du batch sur un compte sans commande et sans Task associée
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
        if (tsk.TaskSubtype == 'Task') {
            hasCallTask = true;
            Assert.AreEqual('Call', tsk.Subject, 'Le sujet de la tâche doit être "Call".');
            Assert.AreEqual('Nouvelle', tsk.Status, 'Le statut de la tâche doit être "Nouvelle".');
            Assert.AreEqual('Normal', tsk.Priority, 'La priorité de la tâche doit être "Normal".');
            Assert.AreEqual(true, tsk.IsReminderSet, 'IsReminderSet doit être true.');
            Assert.AreEqual(System.now().addDays(5).date(), tsk.ReminderDateTime.date(), 'La date du rappel doit être 5 jours après la date actuelle.');
            break;
        }
    }
    Assert.isTrue(hasCallTask, 'Une tâche devrait être associée au compte.');
}
    
    // Test unitaire : exécution du batch sur un compte avec commande et sans Task associée
    @isTest 
    static void testcreateTaskOnAccountWithOrders() {
        Integer sizeTest = 1;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        String activeStatus = 'Yes';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
        
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        TestDataFactory.updateContractsToActivated(conList);
        
        Product2 prod = TestDataFactory.createProduct();
        
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, sizeTest, standardPricebookId);
            
        Test.startTest();

        createTaskOnAccountWithNoOrdersBatch createTaskObj=new createTaskOnAccountWithNoOrdersBatch();
        Database.executeBatch(createTaskObj);
        
        Test.stopTest();
        
    List<Task> insertedTasks = [SELECT Id, WhatId, TaskSubtype FROM Task WHERE WhatId IN :accList];
    
    Boolean hasCallTask = false;
    for (Task tsk : insertedTasks) {
        if (tsk.TaskSubtype == 'Task') {
            hasCallTask = true;
            break;
        }
    }
    Assert.isFalse(hasCallTask, 'Aucune tâche ne doit être associée au compte.');
}
    
 // Test unitaire : exécution du batch sur un compte sans commande et avec 1 Task de type Email associée
    @isTest 
    static void testcreateTaskOnAccountWithNoOrdersWithcallTask() {
        Integer sizeTest = 1;
        String activeStatus = 'No';
        String taskType = 'Email';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);   
        List<Task> taskList = TestDataFactory.createTask(accList, sizeTest, taskType);
            
        Test.startTest();

        createTaskOnAccountWithNoOrdersBatch createTaskObj=new createTaskOnAccountWithNoOrdersBatch();
        Database.executeBatch(createTaskObj);
        
        Test.stopTest();
        
    List<Task> insertedTasks = [SELECT Id, WhatId, TaskSubtype FROM Task WHERE WhatId IN :accList];
  
    Map<Id, Integer> accountCallTaskCount = new Map<Id, Integer>();
    
    for (Task tsk : insertedTasks) {
        if (tsk.TaskSubtype == 'Task') {
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
    
    // Test unitaire : exécution du job qui déclenche le batch sur un compte avec commande et avec 1 Task associée
    @isTest 
    static void testcreateTaskOnAccountWithOrdersWithCallTask() {
        Integer sizeTest = 1;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        String activeStatus = 'Yes';
        String taskType = 'Task';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
        
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        TestDataFactory.updateContractsToActivated(conList);
        
        Product2 prod = TestDataFactory.createProduct();
        
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        Id standardPricebookId = Test.getStandardPricebookId();
        
        List<Order> ordList = TestDataFactory.createOrder(accList, sizeTest, standardPricebookId);
        List<Task> taskList = TestDataFactory.createTask(accList, sizeTest, taskType);
            
        Test.startTest();

        String sch = '0 0 8 12 2 ?';
        ScheduleCreateTaskOnAccountWithNoOrder createTaskObj=new ScheduleCreateTaskOnAccountWithNoOrder();
        System.schedule('JOB', sch, createTaskObj);
        
        Test.stopTest();
        
   List<Task> insertedTasks = [SELECT Id, WhatId, TaskSubtype FROM Task WHERE WhatId IN :accList];
  
    Map<Id, Integer> accountCallTaskCount = new Map<Id, Integer>();
    
    for (Task tsk : insertedTasks) {
        if (tsk.TaskSubtype == 'Task') {
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
    
    // Test unitaire : exécution du batch sur un lot de 200 comptes sans commandes associées et sans task associées
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
        if (tsk.TaskSubtype == 'Task') {
            hasCallTask = true;
            Assert.AreEqual('Call', tsk.Subject, 'Le sujet de la tâche doit être "Call".');
            Assert.AreEqual('Nouvelle', tsk.Status, 'Le statut de la tâche doit être "Nouvelle".');
            Assert.AreEqual('Normal', tsk.Priority, 'La priorité de la tâche doit être "Normal".');
            Assert.AreEqual(true, tsk.IsReminderSet, 'IsReminderSet doit être true.');
            Assert.AreEqual(System.now().addDays(5).date(), tsk.ReminderDateTime.date(), 'La date du rappel doit être 5 jours après la date actuelle.');
            break;
        }
    }
    Assert.isTrue(hasCallTask, 'Une tâche devrait être associée aux comptes.');
}
      @isTest
    static void testScheduleBatch() {
        // On simule l'arrêt du job existant sans quoi on ne pourra pas recréer un job avec le même nom
        // On recherche le job par son nom et on l'arrête
        if (Test.isRunningTest()) {
            List<CronTrigger> existingJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'ScheduleCreateTaskOnAccountWithNoOrder'];
            for (CronTrigger job : existingJobs) {
                System.abortJob(job.Id);
            }
        }

        Test.startTest();

        ScheduleCreateTaskOnAccountWithNoOrder.scheduleBatch();

        Test.stopTest();

        // On récupère le job crée par son nom
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, State 
                          FROM CronTrigger 
                          WHERE CronJobDetail.Name = 'ScheduleCreateTaskOnAccountWithNoOrder'];

        // Je vérifie que le job est crée avec les bons paramètres
        System.assertEquals('0 0 2 ? * 2#1 *', ct.CronExpression, 'La cron expression ne correspond pas');
        System.assertEquals(0, ct.TimesTriggered, 'La tâche ne doit pas encore avoir été déclenchée');
        System.assertEquals('WAITING', ct.State, 'La tâche devrait être en attente');
    }
}
