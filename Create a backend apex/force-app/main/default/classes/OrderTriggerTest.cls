@isTest
private class OrderTriggerTest {
    
    // Test unitaire : Mise à jour de la commande avec article
    @isTest 
    static void testOrderWithOrderItem() {
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
        
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        Test.startTest();

        TestDataFactory.updateOrderToActivated(ordList);
        
        Test.stopTest();
        
        List<Order> updatedOrders = [SELECT id, AccountId, Status FROM Order];
        
        // Vérification du statut de la commande
        for (Order o: updatedOrders) {
            Assert.AreEqual('Activated', o.Status);
        }
    }
    
    // Test unitaire : Mise à jour de la commande sans article associé
    @isTest 
    static void testOrderWithNoOrderItem() {
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

        Boolean hasError = false;
        String errorMessage = '';
        try{
           TestDataFactory.updateOrderToActivated(ordList); 
                     
        }catch(Exception e){
            hasError = true;
            errorMessage = e.getMessage();                     
        }
            
        Test.stopTest();
        
        // Vérification de la génératiion d'une erreur
        Assert.areEqual(true, hasError);
        Assert.isTrue(errorMessage.contains('Il faut ajouter un produit à votre commande.'));
        
    }
    
    // Test unitaire : Mise à jour d'un lot de commande avec article
    @isTest 
    static void testBulkOrderWithOrderItem() {
        Integer sizeTest = 250;
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
        
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        Test.startTest();

        TestDataFactory.updateOrderToActivated(ordList);
        
        Test.stopTest();
        
        List<Order> updatedOrders = [SELECT id, Status FROM Order];

        // Vérification du statut des commandes
        for (Order o: updatedOrders) {
            Assert.AreEqual('Activated', o.Status);
        }
    }

	// Test unitaire : Mise à jour d'un compte après suppression des commandes associées
    @isTest 
    static void testupdateInactiveAccountAfterDeleteAllOrders() {
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

        TestDataFactory.removeAllOrders(ordList);
        
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT id, Active__c FROM Account];

        // Vérification du statut du compte
        for (Account acc: updatedAccounts) {
            Assert.AreEqual('No', acc.Active__c);
        }
    }
    
	// Test unitaire : Mise à jour d'un compte après suppression d'une commande sur deux
    @isTest 
    static void testupdateInactiveAccountAfterDeleteOneOrder() {
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
		
        // On ne récupère qu'une seule commande par compte
        List<Order> ordListToDelete = [SELECT id FROM Order LIMIT 1];
        TestDataFactory.removeAllOrders(ordListToDelete);
        
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT id, Active__c FROM Account];

        // Vérification du statut du compte
        for (Account acc: updatedAccounts) {
            Assert.AreNotEqual('No', acc.Active__c);
        }
    }
    
    // Test unitaire : Mise à jour d'un lot de comptes après suppression de toutes les commandes associées
 	@isTest 
    static void testBulkUpdateInactiveAccountAfterDeleteAllOrders() {
        Integer sizeTest = 250;
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

        TestDataFactory.removeAllOrders(ordList);
        
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT id, Active__c FROM Account];

        // Vérification des statuts des comptes
        for (Account acc: updatedAccounts) {
            Assert.AreEqual('No', acc.Active__c);
        }
    }    
}