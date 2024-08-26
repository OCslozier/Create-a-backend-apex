trigger OrderTrigger on Order (before update, after delete) {
    
    if (Trigger.isUpdate) {  
        OrderService.processOrdersOnStatusChange(Trigger.new);
    } else if (Trigger.isDelete) {
        OrderService.updateInactiveAccountAfterDeleteAllOrders(Trigger.old);
    }
}