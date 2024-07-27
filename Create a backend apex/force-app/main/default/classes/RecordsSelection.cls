public class RecordsSelection {
    
     public static List<OrderItem> getOrderItems(Set<Id> orderIds) {
        return [SELECT Id, OrderId FROM OrderItem WHERE OrderId IN :orderIds];
    }
    
    public static List<Account> getAccountsInAccountIds(Set<Id> accountsIds) {
        return [SELECT Id, Active__c FROM Account WHERE Id IN :accountsIds];
    }
    
    public static List<Order> getRemainingOrders(Set<Id> accountIds, Set<Id> oldOrderIds) {
        return [SELECT Id, AccountId FROM Order WHERE AccountId IN :accountIds AND Id NOT IN :oldOrderIds];
    }
        
}