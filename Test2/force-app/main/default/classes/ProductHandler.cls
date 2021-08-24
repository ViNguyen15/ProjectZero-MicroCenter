public with sharing class ProductHandler {
    

    public static void ProductRestockChecker(List<Product2> updatedProducts){

        for(Product2 toCheck : updatedProducts){
            if(toCheck.Quantity__c <= 0){
                List<Restocks__c> restockOrder = new List<Restocks__c>();
                restockOrder.add(new Restocks__c(name= toCheck.name + ' restock',
                                                 Product__c = toCheck.Id,
                                                 Completed__c = 'NO'));
                System.debug(toCheck);
                Insert restockOrder;
            }
        }
    }

    public ProductHandler() {

    }


}
