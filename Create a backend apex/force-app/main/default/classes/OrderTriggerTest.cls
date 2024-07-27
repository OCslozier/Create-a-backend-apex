@isTest
private class OrderTriggerTest {
    
    // Test unitaire
    @isTest 
    static void testOrderWithOrderItem() {
        // Génération des données de test
        Integer sizeTest = 1;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        String activeStatus = 'Yes';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, sizeTest, standardPricebookId);
        
        // Création des articles de commande
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        Test.startTest();

        TestDataFactory.updateOrderToActivated(ordList);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Order> updatedOrders = [SELECT id, AccountId, Status FROM Order];
        
        // Vérification du chiffre d'affaire
        System.debug('Début du test unitaire ...');
        for (Order o: updatedOrders) {
            Assert.AreEqual('Activated', o.Status);
        }
    }
    // Test unitaire
    @isTest 
    static void testOrderWithNoOrderItem() {
        // Génération des données de test
        Integer sizeTest = 1;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        String activeStatus = 'Yes';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
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
        
        Assert.areEqual(true, hasError);
        Assert.isTrue(errorMessage.contains('Il faut ajouter un produit à votre commande.'));
        
    }
    
    // Test unitaire
    @isTest 
    static void testBulkOrderWithOrderItem() {
        // Génération des données de test
        Integer sizeTest = 250;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        String activeStatus = 'Yes';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, sizeTest, standardPricebookId);
        
        // Création des articles de commande
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        Test.startTest();

        TestDataFactory.updateOrderToActivated(ordList);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Order> updatedOrders = [SELECT id, Status FROM Order];

        // Vérification du chiffre d'affaire
        System.debug('Début du test unitaire ...');
        for (Order o: updatedOrders) {
            Assert.AreEqual('Activated', o.Status);
        }
    }

// Test unitaire
    @isTest 
    static void testupdateInactiveAccountAfterDeleteAllOrders() {
        // Génération des données de test
        Integer sizeTest = 1;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        String activeStatus = 'Yes';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, sizeTest, standardPricebookId);
             
        Test.startTest();

        TestDataFactory.removeAllOrders(ordList);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Account> updatedAccounts = [SELECT id, Active__c FROM Account];

        // Vérification du chiffre d'affaire
        System.debug('Début du test unitaire ...');
        for (Account acc: updatedAccounts) {
            Assert.AreEqual('No', acc.Active__c);
        }
    }
// Test unitaire
    @isTest 
    static void testupdateInactiveAccountAfterDeleteOneOrder() {
        // Génération des données de test
        Integer sizeTest = 1;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        String activeStatus = 'Yes';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, sizeTest, standardPricebookId);
             
        Test.startTest();

        List<Order> ordListToDelete = [SELECT id FROM Order LIMIT 1];
        TestDataFactory.removeAllOrders(ordListToDelete);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Account> updatedAccounts = [SELECT id, Active__c FROM Account];

        // Vérification du chiffre d'affaire
        System.debug('Début du test unitaire ...');
        for (Account acc: updatedAccounts) {
            Assert.AreNotEqual('No', acc.Active__c);
        }
    }
 @isTest 
    static void testBulkUpdateInactiveAccountAfterDeleteAllOrders() {
        // Génération des données de test
        Integer sizeTest = 250;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        String activeStatus = 'Yes';
        
        List<Account> accList = TestDataFactory.createAccount(sizeTest, activeStatus);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, sizeTest, standardPricebookId);
             
        Test.startTest();

        TestDataFactory.removeAllOrders(ordList);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Account> updatedAccounts = [SELECT id, Active__c FROM Account];

        // Vérification du chiffre d'affaire
        System.debug('Début du test unitaire ...');
        for (Account acc: updatedAccounts) {
            Assert.AreEqual('No', acc.Active__c);
        }
    }    
}