trigger TransactionTriggers on Product2 (before insert, before update, 
    before delete, after insert, after update, after delete, after undelete) {


    switch on trigger.operationType {
        when BEFORE_INSERT {}
        when BEFORE_UPDATE{}
        when BEFORE_DELETE{}
        when AFTER_INSERT{}
        when AFTER_UPDATE{
            // for(Product2 toCheck : trigger.New){
            //     if(toCheck.Quantity__c <= 0){
            //         List<Restocks__c> restockOrder = new List<Restocks__c>();
            //         restockOrder.add(new Restocks__c(name= toCheck.name + ' restock',
            //                                          Product__c = toCheck.Id,
            //                                             Completed__c = 'NO'));
            //     	System.debug(toCheck);
            //         Insert restockOrder;
            //     }
            // }

            ProductHandler.ProductRestockChecker(trigger.new);
            
        }
        when AFTER_DELETE{}
        when AFTER_UNDELETE{}
    }
}