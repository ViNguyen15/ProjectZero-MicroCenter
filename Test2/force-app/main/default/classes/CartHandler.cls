public class CartHandler {
    
    public static void CartProductUpdate(List<Cart__c> cart){
        List<Product2> productToUpdate = 
            [SELECT name, quantity__c FROM Product2 WHERE ID = :cart[0].product__c];
        //System.debug(productToUpdate);
        productToUpdate[0].quantity__c--;
        //System.debug(productToUpdate);
        Update productToUpdate;
    }
    
    public static void CartTotal(List<Cart__c> cart){
        List<Checkout__c> checkout = new List<Checkout__c>();
        checkout.add(new Checkout__c(name = 'name',
                                    account__c = cart[0].account__c,
                                    TotalItems__c = 1,
                                    TotalPrice__c = 1));
        System.debug(checkout);
        Upsert checkout;
        
    }
    
    public CartHandler(){}
    
}