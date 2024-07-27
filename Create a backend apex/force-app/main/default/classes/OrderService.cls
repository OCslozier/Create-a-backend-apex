public with sharing class OrderService {

    public static List<Order> checkChangeStatus(List<Order> orders) {
        Map<Id, Order> oldOrdersMap = new Map<Id, Order>((List<Order>) Trigger.old);
        List<Order> ordersToCheck = new List<Order>();

        for (Order newOrder : orders) {
            Order oldOrder = oldOrdersMap.get(newOrder.Id);

            if (oldOrder != null && oldOrder.Status == 'Draft' && newOrder.Status == 'Activated') {
                ordersToCheck.add(newOrder);
            }
        }
        return ordersToCheck;
    }
    
    public static void processOrdersOnStatusChange(List<Order> orders) {
        List<Order> ordersToCheck = checkChangeStatus(orders);
        
        if (!ordersToCheck.isEmpty()) {
            processIfStatusChangeFromDraftToActivated(ordersToCheck);
        }
    }

    public static void processIfStatusChangeFromDraftToActivated(List<Order> orders) {
        OrderService.updateOrderWhenStatusChangeFromDraftToActivated(orders);
    }
    
    public static void updateOrderWhenStatusChangeFromDraftToActivated(List<Order> orders) {
        Set<Id> orderIds = new Set<Id>();

        for (Order order : orders) {
            orderIds.add(order.Id);
        }

        List<OrderItem> orderItems = RecordsSelection.getOrderItems(orderIds);

        Map<Id, List<OrderItem>> orderItemsMap = new Map<Id, List<OrderItem>>();
        for (OrderItem item : orderItems) {
            if (item.OrderId != null) {
                if (!orderItemsMap.containsKey(item.OrderId)) {
                    orderItemsMap.put(item.OrderId, new List<OrderItem>());
                }
                orderItemsMap.get(item.OrderId).add(item);
            }
        }

        for (Order order : orders) {
            if (orderItemsMap.containsKey(order.Id) && !orderItemsMap.get(order.Id).isEmpty()) {
                order.Status = 'Activated';
            } else {
                order.addError('Il faut ajouter un produit à votre commande.');
            }
        }
    }
    
    public static void updateInactiveAccountAfterDeleteAllOrders(List<Order> orders) {
        Set<Id> accountIds = new Set<Id>();
        for (Order order : orders) {
            if (order.AccountId != null) {
                accountIds.add(order.AccountId);
            }
        }

        List<Account> accountsToUpdate = RecordsSelection.getAccountsInAccountIds(accountIds);
        List<Order> remainingOrders = RecordsSelection.getRemainingOrders(accountIds, Trigger.oldMap.keySet());

        Set<Id> accountsWithOrders = new Set<Id>();
        for (Order order : remainingOrders) {
            accountsWithOrders.add(order.AccountId);
        }

        for (Account account : accountsToUpdate) {
            if (!accountsWithOrders.contains(account.Id)) {
                account.Active__c = 'No';
            }
        }

        update accountsToUpdate;
    }
}