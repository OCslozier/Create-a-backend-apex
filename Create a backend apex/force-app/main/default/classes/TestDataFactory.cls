public class TestDataFactory {

    // Création de comptes
    public static List<Account> createAccount(Integer numberOfTestRecords, String ActiveStatus) {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < numberOfTestRecords; i++) {
            Account acc = new Account(
                Name = 'Test Account ' + i,
                Active__c = ActiveStatus
            );
            accList.add(acc);
        }
        insert accList;
        return accList;
    }
    
	public static List<Task> createTask(List<Account> accList, Integer numberOfTestRecords, String taskType) {
        List<Task> taskList = new List<Task>();
        for (Integer i = 0; i < numberOfTestRecords; i++) {
            Task tsk = new Task(
                WhatId = accList[i].Id,
                    Subject = 'Call',
                    Status = 'Nouvelle',
                    Priority = 'Normal',
                    TaskSubtype = taskType,
                    IsReminderSet = true,
					ReminderDateTime = System.now().addDays(5)
            );
            taskList.add(tsk);
        }
        insert taskList;
        return taskList;
    }
    
    // Création de contrats
    public static List<Contract> createContract(List<Account> accList) {
        List<Contract> conList = new List<Contract>();
        for (Account acc : accList) {
            Contract con = new Contract(
                AccountId = acc.Id,
                Status = 'Draft',
                StartDate = Date.valueOf('2024-04-29'),
                ContractTerm = 36
            );
            conList.add(con);
        }
        insert conList;
        return conList;
    }

    // Mise à jour des contrats
    public static void updateContractsToActivated(List<Contract> conList) {
        for (Contract con : conList) {
            con.Status = 'Activated';
        }
        update conList;
    }

    // Création de produit
    public static Product2 createProduct() {
        Product2 prod = new Product2(
            Name = 'TEST',
            IsActive = true
        );
        insert prod;
        return prod;
    }

    // Création d'entrée au catalogue de prix
    public static PricebookEntry createPricebookEntry(Product2 prod, Decimal pricebookUnitPrice) {
        Id standardPricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = prod.Id,
            UnitPrice = pricebookUnitPrice,
            IsActive = true
        );
        insert standardPricebookEntry;
        return standardPricebookEntry;
    }

    // Création des commandes
    public static List<Order> createOrder(List<Account> accList, Integer numberOfTestRecords, Id standardPricebookId) {
        List<Order> ordList = new List<Order>();
        for (Integer i = 0; i < numberOfTestRecords; i++) {
            Order ord = new Order(
                AccountId = accList[i].Id,
                Status = 'Draft',
                EffectiveDate = Date.valueOf('2024-04-29'),
                Pricebook2Id = standardPricebookId
            );
            ordList.add(ord);
            Order ord2 = new Order(
                AccountId = accList[i].Id,
                Status = 'Draft',
                EffectiveDate = Date.valueOf('2024-04-29'),
                Pricebook2Id = standardPricebookId
            );
            ordList.add(ord2);
        }
        insert ordList;
        return ordList;
    
    }

    // Mise à jour des commandes
    public static void updateOrderToActivated(List<Order> ordList) {
        for (Order ord : ordList) {
            ord.Status = 'Activated';
        }
        update ordList;
    }

    // Création des lignes de commandes
    public static List<OrderItem> createOrderItems(List<Order> ordList, PricebookEntry standardPricebookEntry, Decimal unitPrice) {
        List<OrderItem> oiList = new List<OrderItem>();
        for (Order ord : ordList) {
            OrderItem oi = new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = standardPricebookEntry.Id,
                UnitPrice = unitPrice,
                Quantity = 1
            );
            oiList.add(oi);
        }
        insert oiList;
        return oiList;
    }
    
    // Supression de tous les order
    public static void removeAllOrders(List<Order> ordList) {
        delete ordList;
    }
    
}